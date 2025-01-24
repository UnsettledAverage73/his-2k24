import logging
import datetime
import platform
import socket
from pathlib import Path
from reportlab.lib.pagesizes import letter, landscape
from reportlab.platypus import SimpleDocTemplate, Table, TableStyle, Paragraph
from reportlab.lib import colors
from reportlab.lib.styles import getSampleStyleSheet

def generate_report(results, output_display):
    """Generate a PDF report for failed scripts in table format."""
    failed_results = [result for result in results if result["status"] == "FAIL"]
    if not failed_results:
        output_display.append("No failed scripts to generate a report.")
        return
    
    report_dir = Path("reports")
    report_dir.mkdir(exist_ok=True)
    report_filename = report_dir / f"Execution_Report_{datetime.datetime.now().strftime('%Y-%m-%d_%H-%M-%S')}_FAIL_ONLY.pdf"
    create_pdf_report(report_filename, failed_results)
    output_display.append(f"Report generated for failed scripts: {report_filename}")

def create_pdf_report(report_filename, failed_results):
    # Create PDF document with landscape orientation
    doc = SimpleDocTemplate(str(report_filename), pagesize=landscape(letter))
    
    # Prepare styles
    styles = getSampleStyleSheet()
    
    # Prepare report content
    elements = []
    
    # Add system information
    system_info = [
        ["System Information"],
        ["Date", datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')],
        ["Operating System", f"{platform.system()} {platform.release()}"],
        ["OS Version", platform.version()],
        ["IP Address", socket.gethostbyname(socket.gethostname())]
    ]
    
    system_info_table = Table(system_info, colWidths=[200, 400])
    system_info_table.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,0), colors.grey),
        ('TEXTCOLOR', (0,0), (-1,0), colors.whitesmoke),
        ('ALIGN', (0,0), (-1,-1), 'CENTER'),
        ('FONTNAME', (0,0), (-1,0), 'Helvetica-Bold'),
        ('FONTSIZE', (0,0), (-1,0), 14),
        ('BOTTOMPADDING', (0,0), (-1,0), 12),
        ('BACKGROUND', (0,1), (-1,-1), colors.beige),
        ('GRID', (0,0), (-1,-1), 1, colors.black)
    ]))
    elements.append(system_info_table)
    
    # Prepare failed scripts data
    header = ['Serial', 'Script Name', 'Status', 'Output']
    table_data = [header]
    
    for result in failed_results:
        # Truncate output to first 3 lines to keep table readable
        output_preview = '\n'.join(result['output'].splitlines()[:3]) + '...'
        row = [
            str(result.get('serial_number', 'N/A')),
            result['script'],
            result['status'],
            output_preview
        ]
        table_data.append(row)
    
    # Create table
    table = Table(table_data, colWidths=[50, 150, 100, 400])
    table.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,0), colors.grey),
        ('TEXTCOLOR', (0,0), (-1,0), colors.whitesmoke),
        ('ALIGN', (0,0), (-1,-1), 'LEFT'),
        ('FONTNAME', (0,0), (-1,0), 'Helvetica-Bold'),
        ('FONTSIZE', (0,0), (-1,0), 12),
        ('BOTTOMPADDING', (0,0), (-1,0), 12),
        ('BACKGROUND', (0,1), (-1,-1), colors.beige),
        ('GRID', (0,0), (-1,-1), 1, colors.black)
    ]))
    
    elements.append(table)
    
    # Build PDF
    doc.build(elements)
