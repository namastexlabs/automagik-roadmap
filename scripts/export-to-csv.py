#!/usr/bin/env python3
"""
Export Automagik Roadmap to CSV for stakeholder reporting.
Follows SmartFit roadmap CSV structure adapted for Automagik.

Column Mapping (Smart Fit → Automagik):
- FRENTE → PROJECT
- INICIATIVA → INITIATIVE
- DESCRICAO → DESCRIPTION
- ETAPA → STAGE
- ETA → ETA
- RESULTADO_ESPERADO → EXPECTED_RESULT
- FOLLOW_UP → STATUS_DETAIL
- DATA INICIO → START_DATE
- DATA FIM → END_DATE
+ ISSUE_URL (new)
+ WISH_FOLDER (new)
+ OWNER (new)
"""

import os
import csv
import re
from datetime import datetime
from github import Github


def extract_field_from_body(body: str, field_name: str) -> str:
    """Extract a field value from issue body markdown."""
    if not body:
        return ''

    # Look for patterns like "### Field Name" followed by content
    pattern = rf'###?\s+{re.escape(field_name)}\s*\n+(.+?)(?=\n###?|\Z)'
    match = re.search(pattern, body, re.DOTALL | re.IGNORECASE)

    if match:
        content = match.group(1).strip()
        # Clean up markdown formatting
        content = re.sub(r'\*\*(.+?)\*\*', r'\1', content)  # Remove bold
        content = re.sub(r'\n+', ' ', content)  # Single line
        content = re.sub(r'- \[ \]', '', content)  # Remove checkboxes
        content = re.sub(r'- ', '', content)  # Remove bullet points
        return content[:300]  # Limit length

    return ''


def extract_wish_folder(body: str) -> str:
    """Extract wish folder path from issue body."""
    if not body:
        return ''

    # Look for patterns like "projects/omni/wishes/slack-integration/"
    pattern = r'projects/[\w-]+/wishes/[\w-]+/?'
    match = re.search(pattern, body)

    if match:
        return match.group(0)

    return ''


def map_stage_to_etapa(stage: str) -> str:
    """Map GitHub stage labels to Smart Fit ETAPA equivalents."""
    stage_mapping = {
        'ideation': 'Ideação',
        'exploring': 'Investigação',
        'rfc': 'Proposta',
        'priorization': 'Priorização',
        'executing': 'Execução',
        'preview': 'Preview',
        'shipped': 'Finalizado',
        'archived': 'Arquivado'
    }
    return stage_mapping.get(stage, stage.replace('-', ' ').title())


def format_quarter_as_eta(quarter: str) -> str:
    """Format quarter label as ETA (e.g., '2025-q4' → 'Q4 2025')."""
    if not quarter:
        return ''

    # Parse format like "2025-q4"
    match = re.match(r'(\d{4})-q(\d)', quarter, re.IGNORECASE)
    if match:
        year, q = match.groups()
        return f'Q{q} {year}'

    if quarter.lower() == 'backlog':
        return 'BACKLOG'

    return quarter.upper()


def export_roadmap():
    """Export roadmap issues to CSV following Smart Fit structure."""
    token = os.environ.get('GITHUB_TOKEN')
    if not token:
        print("Error: GITHUB_TOKEN environment variable not set")
        return

    g = Github(token)
    repo = g.get_repo('namastexlabs/automagik-roadmap')

    # Get all issues with 'initiative' label
    issues = repo.get_issues(labels=['initiative'], state='all')

    rows = []
    for issue in issues:
        # Extract labels
        project = next((l.name.split(':')[1] for l in issue.labels if l.name.startswith('project:')), '')
        stage = next((l.name.split(':')[1] for l in issue.labels if l.name.startswith('stage:')), '')
        quarter = next((l.name.split(':')[1] for l in issue.labels if l.name.startswith('quarter:')), '')

        # Extract fields from issue body
        expected_result = extract_field_from_body(issue.body, 'Expected Results')
        description = extract_field_from_body(issue.body, 'Description') or extract_field_from_body(issue.body, 'Overview')
        wish_folder = extract_wish_folder(issue.body)

        # Get assignee/owner
        owner = '@' + issue.assignee.login if issue.assignee else ''

        # Clean initiative title
        initiative_title = issue.title.replace('[Initiative] ', '').replace('[initiative] ', '')

        # Map stage to ETAPA
        etapa = map_stage_to_etapa(stage)

        # Format ETA
        eta = format_quarter_as_eta(quarter)

        # Dates (Smart Fit format: DD/MM/YYYY)
        start_date = issue.created_at.strftime('%d/%m/%Y')
        end_date = issue.closed_at.strftime('%d/%m/%Y') if issue.closed_at else ''

        # Status detail - could be extracted from last comment or milestone
        status_detail = 'TRACKED' if issue.state == 'open' else 'DONE'

        rows.append({
            'PROJECT': project.upper() if project else 'UNKNOWN',
            'INITIATIVE': initiative_title,
            'DESCRIPTION': description or (issue.body[:200] if issue.body else ''),
            'STAGE': etapa,
            'ETA': eta,
            'EXPECTED_RESULT': expected_result,
            'STATUS_DETAIL': status_detail,
            'START_DATE': start_date,
            'END_DATE': end_date,
            'ISSUE_URL': issue.html_url,
            'WISH_FOLDER': wish_folder,
            'OWNER': owner
        })

    # Sort by PROJECT, then STAGE, then ETA
    rows.sort(key=lambda x: (x['PROJECT'], x['STAGE'], x['ETA']))

    # Ensure exports directory exists
    os.makedirs('exports', exist_ok=True)

    # Write CSV with Smart Fit compatible column order
    filename = f"exports/roadmap-{datetime.now().strftime('%Y-%m-%d')}.csv"

    if rows:
        # Column order matching Smart Fit template
        fieldnames = [
            'PROJECT',
            'INITIATIVE',
            'DESCRIPTION',
            'STAGE',
            'ETA',
            'EXPECTED_RESULT',
            'STATUS_DETAIL',
            'START_DATE',
            'END_DATE',
            'ISSUE_URL',
            'WISH_FOLDER',
            'OWNER'
        ]

        with open(filename, 'w', newline='', encoding='utf-8') as f:
            writer = csv.DictWriter(f, fieldnames=fieldnames)
            writer.writeheader()
            writer.writerows(rows)

        print(f"✓ Exported {len(rows)} initiatives to {filename}")
        print(f"  Columns: {', '.join(fieldnames)}")
    else:
        print("⚠ No initiatives found to export")


if __name__ == '__main__':
    export_roadmap()
