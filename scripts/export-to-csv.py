#!/usr/bin/env python3
"""
Export Automagik Roadmap to CSV (SmartFit format)
Generates weekly snapshots for stakeholder reporting
"""
import os
import csv
from datetime import datetime
from github import Github


def export_roadmap():
    """Export roadmap issues to CSV file"""
    g = Github(os.environ['GITHUB_TOKEN'])
    repo = g.get_repo('namastexlabs/automagik-roadmap')

    # Get all issues with 'initiative' label
    issues = repo.get_issues(labels=['initiative'], state='all')

    rows = []
    for issue in issues:
        # Extract labels by dimension
        project = next((l.name.split(':')[1] for l in issue.labels if l.name.startswith('project:')), '')
        stage = next((l.name.split(':')[1] for l in issue.labels if l.name.startswith('stage:')), '')
        quarter = next((l.name.split(':')[1] for l in issue.labels if l.name.startswith('quarter:')), '')
        priority = next((l.name.split(':')[1] for l in issue.labels if l.name.startswith('priority:')), '')

        # Parse issue body for structured data
        body = issue.body or ''

        # Extract expected results (basic parsing)
        expected_result = ''
        if 'Expected Results' in body or 'RESULTADO_ESPERADO' in body:
            lines = body.split('\n')
            for i, line in enumerate(lines):
                if 'Expected Results' in line or 'RESULTADO_ESPERADO' in line:
                    # Get next few non-empty lines
                    results = []
                    for j in range(i+1, min(i+5, len(lines))):
                        if lines[j].strip() and not lines[j].startswith('#'):
                            results.append(lines[j].strip())
                    expected_result = ' | '.join(results)[:200]
                    break

        # Extract wish folder
        wish_folder = ''
        if 'Wish Folder' in body:
            lines = body.split('\n')
            for i, line in enumerate(lines):
                if 'Wish Folder' in line and i+1 < len(lines):
                    wish_folder = lines[i+1].strip()
                    break

        rows.append({
            'PROJECT': project.upper(),
            'INITIATIVE': issue.title,
            'DESCRIPTION': (body[:200] + '...') if len(body) > 200 else body,
            'STAGE': stage.replace('-', ' ').title(),
            'QUARTER': quarter.upper(),
            'EXPECTED_RESULT': expected_result,
            'STATUS_DETAIL': f"{len([c for c in issue.get_comments()])} comments",
            'PRIORITY': priority.upper(),
            'OWNER': issue.assignee.login if issue.assignee else '',
            'CREATED': issue.created_at.strftime('%Y-%m-%d'),
            'UPDATED': issue.updated_at.strftime('%Y-%m-%d'),
            'ISSUE_URL': issue.html_url,
            'WISH_FOLDER': wish_folder
        })

    # Write CSV
    os.makedirs('exports', exist_ok=True)
    filename = f"exports/roadmap-{datetime.now().strftime('%Y-%m-%d')}.csv"

    if rows:
        with open(filename, 'w', newline='', encoding='utf-8') as f:
            writer = csv.DictWriter(f, fieldnames=rows[0].keys())
            writer.writeheader()
            writer.writerows(rows)
        print(f"✅ Exported {len(rows)} initiatives to {filename}")
    else:
        print("⚠️ No initiatives found to export")


if __name__ == '__main__':
    export_roadmap()
