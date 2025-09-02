-- GRC Rating Application Database Schema

-- Create database (run this separately)
-- CREATE DATABASE grc_rating_db;

-- Vendors table
CREATE TABLE vendors (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    logo_url VARCHAR(500),
    summary TEXT,
    pricing_estimate VARCHAR(255),
    website_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Vendor scores table (for benchmark scoring)
CREATE TABLE vendor_scores (
    id SERIAL PRIMARY KEY,
    vendor_id INTEGER REFERENCES vendors(id) ON DELETE CASCADE,
    risk_management DECIMAL(3,2) CHECK (risk_management >= 0 AND risk_management <= 5),
    compliance_management DECIMAL(3,2) CHECK (compliance_management >= 0 AND compliance_management <= 5),
    audit_incident_management DECIMAL(3,2) CHECK (audit_incident_management >= 0 AND audit_incident_management <= 5),
    workflow_automation DECIMAL(3,2) CHECK (workflow_automation >= 0 AND workflow_automation <= 5),
    integration_apis DECIMAL(3,2) CHECK (integration_apis >= 0 AND integration_apis <= 5),
    ease_of_use DECIMAL(3,2) CHECK (ease_of_use >= 0 AND ease_of_use <= 5),
    monitoring_dashboards DECIMAL(3,2) CHECK (monitoring_dashboards >= 0 AND monitoring_dashboards <= 5),
    vendor_third_party_risk DECIMAL(3,2) CHECK (vendor_third_party_risk >= 0 AND vendor_third_party_risk <= 5),
    pricing_value DECIMAL(3,2) CHECK (pricing_value >= 0 AND pricing_value <= 5),
    scalability_support DECIMAL(3,2) CHECK (scalability_support >= 0 AND scalability_support <= 5),
    overall_score DECIMAL(5,2) GENERATED ALWAYS AS (
        ROUND((risk_management*1.5 + compliance_management*1.5 + audit_incident_management*1.2 +
               workflow_automation*1 + integration_apis*0.8 + ease_of_use*1 + monitoring_dashboards*0.7 +
               vendor_third_party_risk*0.7 + pricing_value*0.6 + scalability_support*1) / 10, 2)
    ) STORED,
    star_rating DECIMAL(3,1) GENERATED ALWAYS AS (
        ROUND((risk_management*1.5 + compliance_management*1.5 + audit_incident_management*1.2 +
               workflow_automation*1 + integration_apis*0.8 + ease_of_use*1 + monitoring_dashboards*0.7 +
               vendor_third_party_risk*0.7 + pricing_value*0.6 + scalability_support*1) / 10, 1)
    ) STORED,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- User reviews table
CREATE TABLE reviews (
    id SERIAL PRIMARY KEY,
    vendor_id INTEGER REFERENCES vendors(id) ON DELETE CASCADE,
    reviewer_name VARCHAR(255),
    review_text TEXT NOT NULL,
    user_rating DECIMAL(3,1) CHECK (user_rating >= 1 AND user_rating <= 5),
    is_approved BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample vendor data
INSERT INTO vendors (name, logo_url, summary, pricing_estimate, website_url) VALUES
('Vanta', 'https://media.licdn.com/dms/image/v2/D560BAQGm_Mgx3KYMRA/company-logo_200_200/company-logo_200_200/0/1683744826721/vanta_security_logo?e=1758153600&v=beta&t=ezlUlSBrxv9pv8hk-D7hW2-1Ka9P3yaUVCjtxIUkz4w', 'Automated compliance platform for SOC 2, ISO 27001, and more security frameworks', '$500-2000/month', 'https://vanta.com'),
('Drata', 'https://media.licdn.com/dms/image/v2/D560BAQGx4-21-kqwiA/company-logo_200_200/B56ZUceLQtHsAI-/0/1739939428384/drata_logo?e=1758153600&v=beta&t=L_ViuJ-mCtTthH22w6Rjbz0Y-dbZI_88z76tWtEL9hk', 'Continuous compliance monitoring and security audit automation platform', '$600-2500/month', 'https://drata.com'),
('RSA Archer', 'https://media.licdn.com/dms/image/v2/D560BAQFsSDCAZviNFQ/company-logo_200_200/B56ZhXIONOG4AQ-/0/1753808430219/archer_integrated_risk_management_logo?e=1758153600&v=beta&t=32U7EavDTn1tXZho2jsP9O98Hn0b15Zlot8wKIW7t5M', 'Enterprise GRC platform for risk management and compliance operations', '$10000-50000/year', 'https://www.archerirm.com'),
('MetricStream', 'https://media.licdn.com/dms/image/v2/D560BAQFbuWgokvZ8Hg/company-logo_200_200/B56ZbJqQjZGkAI-/0/1747140021030/metricstream_logo?e=1758153600&v=beta&t=XlZlD3GEyWT-ca5QEZtm6ZZI3aH9foNKQivgQGjw3Ug', 'Integrated risk management and GRC cloud platform', '$15000-75000/year', 'https://metricstream.com'),
('IBM OpenPages', 'https://media.licdn.com/dms/image/v2/D560BAQGiz5ecgpCtkA/company-logo_200_200/company-logo_200_200/0/1688684715866/ibm_logo?e=1758153600&v=beta&t=C31b8CcrPfbmnFuB9jD67Gr8EQDVZEZhGulD6OlfpnM', 'AI-powered GRC platform for enterprise risk and compliance management', '$20000-100000/year', 'https://ibm.com/products/openpages'),
('LogicGate', 'https://media.licdn.com/dms/image/v2/D4E0BAQFmVPonyoX0FA/company-logo_200_200/company-logo_200_200/0/1734016889456/logic_gate_logo?e=1758153600&v=beta&t=SBNOvJPUQYKjHYgfXmLKSI76_twa9XgPTMeZI1v1dvA', 'Risk management and compliance automation platform', '$800-3000/month', 'https://logicgate.com'),
('ServiceNow GRC', 'https://media.licdn.com/dms/image/v2/D560BAQG-sNe0_VNRnQ/company-logo_200_200/B56Zak7lUsGgAI-/0/1746523805288/servicenow_logo?e=1758153600&v=beta&t=3Cqd4UoFH--lI5kJ7uKAWDBXzT8dwIPzfLNzHy-kZtc', 'Integrated governance, risk, and compliance on the Now Platform', '$25000-150000/year', 'https://servicenow.com/products/grc.html'),
('OneTrust', 'https://media.licdn.com/dms/image/v2/D560BAQH2azTI7cMzIg/company-logo_200_200/company-logo_200_200/0/1665577396653/onetrust_logo?e=1758153600&v=beta&t=69fDed-JQlAMOBfPLwTBKe3R5nNVAL-Ww5Adz9vVFtE', 'Privacy, data governance, and third-party risk management platform', '$1000-5000/month', 'https://onetrust.com'),
('Resolver', 'https://media.licdn.com/dms/image/v2/C560BAQELq4ruWu8iFg/company-logo_200_200/company-logo_200_200/0/1654783539967/resolver_inc_logo?e=1758153600&v=beta&t=ZcrOUy6891BhAD7DT0yTp3lUWQExz5dn7Vb7hX-J9UQ', 'Integrated risk management and digital resilience platform', '$5000-25000/year', 'https://resolver.com'),
('Allgress', 'https://media.licdn.com/dms/image/v2/D4D0BAQEX9ujQuru3Tg/company-logo_200_200/company-logo_200_200/0/1728575633343/allgress_inc_logo?e=1758153600&v=beta&t=FDZnxrN3OGiKWfQ739wiSqT5dRMDT5aMO-c0QzD1xjg', 'Cloud-based GRC platform for mid-market enterprises', '$2000-8000/month', 'https://allgress.com');

-- Large-scale enterprise & legacy platforms
INSERT INTO vendors (name, logo_url, summary, pricing_estimate, website_url) VALUES
('Workiva', 'https://media.licdn.com/dms/image/v2/C560BAQHGtsgiZOVMzQ/company-logo_200_200/company-logo_200_200/0/1630649270662/workiva_logo?e=1758153600&v=beta&t=4Cpoeu4xU-XaxUgLSQ2Gq610nljF9fAiyoRWb6G_KTc', 'Cloud platform specializing in financial and regulatory reporting, audit & compliance workflows', 'custom/enterprise pricing', 'https://workiva.com'),
('SAP GRC', 'https://media.licdn.com/dms/image/v2/D560BAQGmwwo0aq4jVA/company-logo_200_200/company-logo_200_200/0/1723034255614/sap_logo?e=1758153600&v=beta&t=EoCVfWbONC36CqTDr483Rrfssz6dAMbvUTOaZMct7uc', 'Integrated suite embedded in SAP ERP for access control, process control, risk & compliance', 'custom/enterprise pricing', 'https://sap.com/products/grc'),
('Oracle Risk Management and Compliance', 'https://media.licdn.com/dms/image/v2/D4E0BAQHYCgYovUuPtQ/company-logo_200_200/company-logo_200_200/0/1665755678957/oracle_logo?e=1758153600&v=beta&t=6y9LeW3cHs-bdndq8lSxCq116pzC9ijh7-TAhycJCJQ', 'Governance, risk and compliance tools integrated with Oracle ERP and Fusion', 'custom/enterprise pricing', 'https://oracle.com'),
('AuditBoard', 'https://media.licdn.com/dms/image/v2/D560BAQGFD0snTGMrwg/company-logo_200_200/B56ZZjWpANHgAM-/0/1745423604096/auditboard_logo?e=1758153600&v=beta&t=VZtu-aRNSi5wNOdp7YiuvZ45MUsWdjO6yhcWA-QZxjA', 'Cloud-native platform for audit, risk, compliance, ESG and workflow automation', 'custom/Mid-Enterprise pricing', 'https://auditboard.com'),
('Riskonnect', 'https://media.licdn.com/dms/image/v2/C560BAQHjG_nf9WKmuw/company-logo_200_200/company-logo_200_200/0/1631385246791?e=1758153600&v=beta&t=wpFqvzvWIDS_QDYlH2qI820DAyCtxY8eNrHwIV646nM', 'Connected risk management platform for ERM, compliance audits, incident tracking, ESG', '$10k-50k/year', 'https://riskonnect.com'),
('LogicManager', 'https://media.licdn.com/dms/image/v2/C4D0BAQHNiJk301LBzw/company-logo_200_200/company-logo_200_200/0/1630567260835/logicmanager_inc_logo?e=1758153600&v=beta&t=ubijPyR04O0ZzE5fSs1G0GN-B6bxiaqB-a0ISSDoiBQ', 'Risk-based compliance, vendor risk and incident management with strong support services', '$5k-30k/year', 'https://logicmanager.com'),
('Onspring', 'https://media.licdn.com/dms/image/v2/D560BAQGoA9zqiewCPQ/company-logo_200_200/B56ZiFWakqHkAI-/0/1754583903227/onspring_technologies_logo?e=1758153600&v=beta&t=RZUkKwtQmfOKpDVbRfPM385gcVj1gi-P1CKcIyulw3c', 'Configurable no-code GRC workflows, dashboards & reporting for audit, vendor risk, incidents', '$7k-25k/year', 'https://onspring.com'),
('ZenGRC', 'https://media.licdn.com/dms/image/v2/D560BAQEgMmfrVgrxQA/company-logo_200_200/company-logo_200_200/0/1719882500303/riskoptics_logo?e=1758153600&v=beta&t=kw8AG81ezVHle580LtMnFDr6Yd5Q8Bdi-p-rWYJOneM', 'Simple, intuitive compliance tracking and risk management with mapped frameworks', '$10k-30k/year', 'https://zengrc.com'),
('Convercent', 'https://media.licdn.com/dms/image/v2/D560BAQH2azTI7cMzIg/company-logo_200_200/company-logo_200_200/0/1665577396653/onetrust_logo?e=1758153600&v=beta&t=69fDed-JQlAMOBfPLwTBKe3R5nNVAL-Ww5Adz9vVFtE', 'Ethics & compliance risk platform with policy management, hotline and case handling', '$5k-20k/year', 'https://convercent.com'),
('TraceSecurity', 'https://media.licdn.com/dms/image/v2/C4E0BAQG2EE_05cqTLg/company-logo_200_200/company-logo_200_200/0/1630627689006/tracesecurity_logo?e=1758153600&v=beta&t=Q5G7zTAuFkMU_9i2rzgc68yyTfgNgf0GCBUlryjjh-U', 'Cloud-based IT GRC tools for compliance, audit, risk and phishing simulation', '$3k-15k/year', 'https://tracesecurity.com'),
('Lepide', 'https://media.licdn.com/dms/image/v2/C560BAQE0ulCTGYh9fQ/company-logo_200_200/company-logo_200_200/0/1630564579618/lepide_software_pvt_ltd__logo?e=1758153600&v=beta&t=2RFXjdKNtTyWJlYVx2r4w7ztL-rAWSYUw9VDkWLGEHA', 'UK-based data governance and compliance platform with modules for access governance, auditing, and insider threat detection.', 'custom/mid-enterprise pricing', 'https://lepide.com');

-- Emerging/niche and SMB-focused platforms
INSERT INTO vendors (name, logo_url, summary, pricing_estimate, website_url) VALUES
('Apptega', 'https://media.licdn.com/dms/image/v2/D4E0BAQGXy2y7m-dd3Q/company-logo_200_200/company-logo_200_200/0/1706293097459/apptega_logo?e=1758153600&v=beta&t=P8jU8Us-1hIR5h1ynlThdFiAKz3dQW8cMdFmp4URy2w', 'Continuous compliance and cybersecurity risk platform with framework cross-walking and multi-tenant support', '$400-1000/month', 'https://apptega.com'),
('StandardFusion', 'https://media.licdn.com/dms/image/v2/C4D0BAQEwCQXgNXCHFQ/company-logo_200_200/company-logo_200_200/0/1654283277489/standardfusion_logo?e=1758153600&v=beta&t=bwnxQZ5wfQSl-dipHavj-w4yykveLYTDUZ8sdk_uLOs', 'User-friendly SaaS for audit, risk & compliance management focused on SMBs', '$500-2000/month', 'https://standardfusion.com'),
('Hyperproof', 'https://media.licdn.com/dms/image/v2/D4E0BAQH2db-oqxc84A/company-logo_200_200/B4EZi9QBxuGoAM-/0/1755521752590/hyperproof_logo?e=1758153600&v=beta&t=GrwqKcyTOvrbBv54D72DnGPSpzVh2jKMXZfxXoFjBMM', 'Compliance and risk management tool with automated evidence collection and audit workflows', '$600-2500/month', 'https://hyperproof.com'),
('Sprinto', 'https://media.licdn.com/dms/image/v2/D4D0BAQE2rlN35F9YOA/company-logo_200_200/company-logo_200_200/0/1665581599036/sprinto_com_logo?e=1758153600&v=beta&t=rP2kJ0s6P-vht726duQSGtLRLzTA3DTGriRX9if39pw', 'Cloud compliance automation for SOC2, GDPR, ISO that scales for startups & SMEs', '$500-1500/month', 'https://sprinto.com'),
('ControlMap', 'https://media.licdn.com/dms/image/v2/D5633AQFBdReh_CMpCw/productpage-logo-image_200_200/productpage-logo-image_200_200/0/1718146229180/scalepad_controlmap_logo?e=1757376000&v=beta&t=VAYXOf6k54aLLj1oJqp8Lz5IKWqik3BFBglbWDd8l2w', 'Automated compliance mapping for SOC2, ISO 27001 with Jira integration', 'from free tier to $500/month', 'https://controlmap.com'),
('Parapet', 'https://media.licdn.com/dms/image/v2/D560BAQHvIfSNWoXc0A/company-logo_200_200/B56ZdbmcqRHoAI-/0/1749588495380/parapetirm_logo?e=1758153600&v=beta&t=sc0OK4zc9XtlDn7ZRJn21yNZEty07tzCnLy3bBKGkF8', 'Enterprise safety, compliance, audit & health management at affordable pricing', '$3/user/month', 'https://parapet.com'),
('intelliGRC', 'https://media.licdn.com/dms/image/v2/C4E0BAQGi57rvw9Zxow/company-logo_200_200/company-logo_200_200/0/1677602836481/intelligrc_logo?e=1758153600&v=beta&t=R0P2_35e0ZraaByyEOfsWsvWMOwNLPGRIPAh5TET8rU', 'Focused compliance tooling for CMMC and SMEs, accessible pricing', '$400/user/month (~$4800/year)', 'https://intelligrc.com'),
('CISO Assistant', 'https://media.licdn.com/dms/image/v2/D4E33AQGL1WRgoDs9nw/productpage-logo-image_200_200/productpage-logo-image_200_200/0/1711223887458/intuitem_ciso_assistant_logo?e=1757376000&v=beta&t=HtykvvOepik2bck1XRR3Vc2I6D8d7FKmAuGkFt-ILNM', 'Community-edition and paid tool for risk frameworks coverage and risk registers', 'free-to-paid tiers', 'https://cisoassistant.io'),
('Eramba', 'https://media.licdn.com/dms/image/v2/C4D0BAQGeUjZINUC1jQ/company-logo_200_200/company-logo_200_200/0/1662968814080/eramba_logo?e=1758153600&v=beta&t=cFb-dT22reNUeofO3FH13jl2TgMalA_7yAHKXIF6kCY', 'Open-source and enterprise GRC platform, cost-effective with strong core functionality', 'free for on-prem + optional consulting (~$6K setup)', 'https://eramba.org'),
('Panorays', 'https://media.licdn.com/dms/image/v2/D4D0BAQEMCzEZddSaWA/company-logo_200_200/company-logo_200_200/0/1699513956093/panorays_logo?e=1758153600&v=beta&t=c_DwACzmWi8vKEEbiuDVf0HmpK6ls-BJhcuf4GdCp00', 'Automated third-party security risk management with peer benchmarking', '$5000-15000/year', 'https://panorays.com');

INSERT INTO vendors (name, logo_url, summary, pricing_estimate, website_url) VALUES
('Cyber Sierra', 'https://media.licdn.com/dms/image/v2/D560BAQHAkx7xtTQy1Q/company-logo_200_200/company-logo_200_200/0/1699608907430/cybersierra_logo?e=1758153600&v=beta&t=B9dibcyQ2zvLJUgDyEhaxTpYRARgzQfxPxdQ2QB4tJE',
 'AI-enabled cybersecurity platform offering continuous control monitoring, third-party risk management, and GRC automation across frameworks like SOC2, ISO 27001, GDPR, HIPAA, PCI DSS, and custom controls',
 'custom enterprise pricing', 'https://cybersierra.co');

 -- 1. Scrut Automation
INSERT INTO vendors (name, logo_url, summary, pricing_estimate, website_url) VALUES
('Scrut Automation', 'https://media.licdn.com/dms/image/v2/D560BAQEsRFHENZj_UQ/company-logo_200_200/B56ZfU7wYvGoAI-/0/1751624124748/scrut_automation_logo?e=1758153600&v=beta&t=oaQaSJKQGQX3TQTM45wCDwv7gjfdnpDPmav5Z2BQE0Q', 'Risk-first compliance automation supporting 50+ frameworks, with powerful integrations and dashboards', 'custom/mid-enterprise pricing', 'https://scrut.io');

-- 2. Thoropass
INSERT INTO vendors (name, logo_url, summary, pricing_estimate, website_url) VALUES
('Thoropass', 'https://media.licdn.com/dms/image/v2/C560BAQH2S9OV9B6cNg/company-logo_200_200/company-logo_200_200/0/1680048629650/heylaika_logo?e=1758153600&v=beta&t=w_ZbfDkP87Yc_uFqWiKqfAYtzNPrtxL2Tk1KrK3jhl0', 'AI-native audit and compliance platform that includes both automation and auditing services', 'custom/mid-enterprise pricing', 'https://thoropass.com');

-- 3. Diligent One
INSERT INTO vendors (name, logo_url, summary, pricing_estimate, website_url) VALUES
('Diligent One', 'https://media.licdn.com/dms/image/v2/D4E0BAQGoBATEkMWfSA/company-logo_200_200/company-logo_200_200/0/1700083885027/diligent_board_member_services_logo?e=1758153600&v=beta&t=QmcHPg_ecP0ZzZO2jvnTSlpw5XmG17uOLIJFmYDLy44', 'Cloud-based governance, risk, audit, and compliance platform emphasizing workflow automation and analytics', 'custom/enterprise pricing', 'https://diligent.com');

-- 4. SAI360
INSERT INTO vendors (name, logo_url, summary, pricing_estimate, website_url) VALUES
('SAI360', 'https://media.licdn.com/dms/image/v2/D4E0BAQG_495F2oCh6A/company-logo_200_200/company-logo_200_200/0/1709415875689/sai360_logo?e=1758153600&v=beta&t=SislCzVgXQCdSiLVuondEMELffYdbbIdUmD-HtxzDDM', 'Comprehensive GRC and third-party risk management platform strong in monitoring third-party access', 'custom/enterprise pricing', 'https://sai360.com');

-- 5. Fusion Framework System
INSERT INTO vendors (name, logo_url, summary, pricing_estimate, website_url) VALUES
('Fusion Framework System', 'https://media.licdn.com/dms/image/v2/D560BAQFkfCmj5Cl1mA/company-logo_200_200/company-logo_200_200/0/1689177916340/fusion_risk_management_logo?e=1758153600&v=beta&t=Jka8Cjc3O7GbidRbMyIAel1FfJmtUl8CxEF--jeFrSQ', 'Salesforce-based GRC focusing on business continuity and resilience', 'custom/enterprise pricing', 'https://fusiongci.com');

-- 6. Mitratech Alyne
INSERT INTO vendors (name, logo_url, summary, pricing_estimate, website_url) VALUES
('Mitratech Alyne', 'https://media.licdn.com/dms/image/v2/D560BAQFZ2nH7NHhJuA/company-logo_200_200/B56ZUjoIcGGoAM-/0/1740059478100/miratech_logo?e=1758153600&v=beta&t=RBXuQgeW6dyM0AiPbvcQXCVFcAmcE5LzA_eIiL0baRQ', 'AI-driven GRC platform with rich templates and continuous compliance capabilities', 'custom/enterprise pricing', 'https://mitratech.com');

-- 7. Enablon
INSERT INTO vendors (name, logo_url, summary, pricing_estimate, website_url) VALUES
('Enablon', 'https://media.licdn.com/dms/image/v2/C4D0BAQF-R-M-_F0nAg/company-logo_200_200/company-logo_200_200/0/1630554518683/enablon_logo?e=1758153600&v=beta&t=sIB91nHcjy0otrdtyTNxpox5t-W9nN_SWSHUn57sIzw', 'EHS, ESG and GRC software widely used in sustainability-focused sectors such as energy and manufacturing', 'custom/enterprise pricing', 'https://enablon.com');

-- 8. TeamMate+
INSERT INTO vendors (name, logo_url, summary, pricing_estimate, website_url) VALUES
('TeamMate+', 'https://media.licdn.com/dms/image/v2/C4E0BAQGEH0VDbAwMRg/company-logo_200_200/company-logo_200_200/0/1630575534911/teammateaudit_logo?e=1758153600&v=beta&t=wkTDqZBl11fz9jfYvrA0EAqw_kPay4ho_s8s0pkwdio', 'Audit-focused GRC and internal audit platform widely adopted in EMEA by Wolters Kluwer.', 'custom/enterprise pricing', 'https://www.wolterskluwer.com/en/solutions/teammate/teammate-audit');

-- 9. Compliance Manager GRC
INSERT INTO vendors (name, logo_url, summary, pricing_estimate, website_url) VALUES
('Risk3Sixty fullCircle', 'https://media.licdn.com/dms/image/v2/D560BAQFcEu_hNvJS6Q/company-logo_200_200/company-logo_200_200/0/1698444395856/risk3sixty_logo?e=1758153600&v=beta&t=9VLQS_TjWeOrleLfv92HIG4USLl-KmDFcX22_qOiEMY', 'Emerging GRC platform praised by users for harmonizing multiple frameworks and audit automation.', 'custom/mid-enterprise pricing', 'https://risk3sixty.com/fullcircle-grc');

-- 10. Pathlock (Control-Self-Service by Pathlock)
INSERT INTO vendors (name, logo_url, summary, pricing_estimate, website_url) VALUES
('Pathlock (Control-Self-Service)', 'https://media.licdn.com/dms/image/v2/D4E0BAQGgwLAAYopyZg/company-logo_200_200/company-logo_200_200/0/1730666082629/pathlock_logo?e=1758153600&v=beta&t=bJfSbXvzi9ZS3QF2Jr-CBV6_r_fhDqUGenFSnpSjdU8', 'Access governance and GRC tool focusing on audit and compliance with ERP systems', 'custom/enterprise pricing', 'https://pathlock.com');

-- 11. Secureframe (mid-level emerging)
INSERT INTO vendors (name, logo_url, summary, pricing_estimate, website_url) VALUES
('Secureframe', 'https://media.licdn.com/dms/image/v2/D4E0BAQHzTq03Q7dIDQ/company-logo_200_200/company-logo_200_200/0/1696367488334/secureframe_logo?e=1758153600&v=beta&t=uRUYnrz5ujBNXwXdl2X40bh0U5zttFaTsBWbgLkqB0E', 'Automated security and compliance platform helping with SOC 2, ISO 27001, GDPR, and vendor risk', 'custom/mid-enterprise pricing', 'https://secureframe.com');

-- 12. MEGA International
INSERT INTO vendors (name, logo_url, summary, pricing_estimate, website_url) VALUES
('MEGA International', 'https://media.licdn.com/dms/image/v2/D4E0BAQGuswuaGDC3tw/company-logo_200_200/B4EZfGiJJPHcAM-/0/1751382529028/mega_international_logo?e=1758153600&v=beta&t=9nygcC2sEAwwuNN4hOFkr2Ctj-EMTQ9n9iLOp0Ni4r0', 'French-origin HOPEX enterprise GRC suite for architecture, governance, risk and compliance across global regions.', 'custom/enterprise pricing', 'https://mega.com');

-- 13. TrustArc (Privacy-focused GRC)
INSERT INTO vendors (name, logo_url, summary, pricing_estimate, website_url) VALUES
('TrustArc', 'https://media.licdn.com/dms/image/v2/D560BAQEZvU9LQBlK0Q/company-logo_200_200/company-logo_200_200/0/1711545481129/trustarc_logo?e=1758153600&v=beta&t=p9HPEX65xplBtEcPeMbyUXPUuOc1bdpIzzfVXx3Wwis', 'Privacy, governance and compliance platform focused on data protection and regulatory frameworks', 'custom/mid-enterprise pricing', 'https://trustarc.com');

-- 14. IsoMetrix (mid-market GRC)
INSERT INTO vendors (name, logo_url, summary, pricing_estimate, website_url) VALUES
('IsoMetrix', 'https://media.licdn.com/dms/image/v2/C4E0BAQHjzLgA03iLcg/company-logo_200_200/company-logo_200_200/0/1649318436815/isometrix_software_logo?e=1758153600&v=beta&t=yoi9jcmIKLmcd_k6qsIyxga5jMPuN6SlP-MkaYqIdnw', 'GRC, EHS and quality risk platform for SMBs with configurable dashboards and workflows', 'custom/mid-enterprise pricing', 'https://isometrix.com');

-- 15. Quantivate (mid-market)
INSERT INTO vendors (name, logo_url, summary, pricing_estimate, website_url) VALUES
('Quantivate', 'https://media.licdn.com/dms/image/v2/D4D0BAQE95K0nq0YFIw/company-logo_200_200/company-logo_200_200/0/1702496812724/quantivate_logo?e=1758153600&v=beta&t=hA3Xcv6pvnhm0OK1Ajb09zbt8UAMgwf030BeawwV_3Q', 'Risk, compliance, and audit management platform suited to mid-market organizations', 'custom/mid-enterprise pricing', 'https://quantivate.com');

-- 16. NAVEX Global (Ethics & compliance)
INSERT INTO vendors (name, logo_url, summary, pricing_estimate, website_url) VALUES
('NAVEX Global', 'https://media.licdn.com/dms/image/v2/D4E0BAQGu4qYFDbHrlg/company-logo_200_200/company-logo_200_200/0/1695914791808/navexinc_logo?e=1758153600&v=beta&t=JWmNQdRpEcD-BrghT0GGDq_vgWjJKMWh2kVg1ZbMJ4M', 'Ethics, compliance risk and policy management platform focused on ethics & hotline management', 'custom/enterprise pricing', 'https://navexglobal.com');

-- 17. SimpleRisk (small-business friendly open platform)
INSERT INTO vendors (name, logo_url, summary, pricing_estimate, website_url) VALUES
('SimpleRisk', 'https://media.licdn.com/dms/image/v2/C4E0BAQEUojIG_F17rw/company-logo_200_200/company-logo_200_200/0/1631352449782?e=1758153600&v=beta&t=Dhua_yq8VsrQkGkDaI3RsTHnW7G0ntBLIqReYFItOV4', 'Flexible and affordable risk-centric GRC platform for small to mid-sized organizations', 'custom/small-business pricing', 'https://simplerisk.com');

-- 18. GBTEC
INSERT INTO vendors (name, logo_url, summary, pricing_estimate, website_url) VALUES
('GBTEC', 'https://media.licdn.com/dms/image/v2/D560BAQHXeAIsoq--NA/company-logo_200_200/company-logo_200_200/0/1737618993454/gbtec_group_logo?e=1758153600&v=beta&t=YQ_eEXK6OucRzrEtaFDvRmvbFWKYwEK6L4Dqd2Opelc', 'Highly configurable and scalable GRC solution from Germany targeting governance, risk, and compliance.', 'custom/mid-enterprise pricing', 'https://www.gbtec.com');


-- Insert sample benchmark scores
INSERT INTO vendor_scores (vendor_id, risk_management, compliance_management, audit_incident_management, workflow_automation, integration_apis, ease_of_use, monitoring_dashboards, vendor_third_party_risk, pricing_value, scalability_support) VALUES
(1, 4.2, 4.8, 4.1, 4.3, 4.0, 4.6, 4.2, 3.8, 4.1, 4.0),
(2, 4.3, 4.7, 4.2, 4.4, 4.1, 4.5, 4.3, 3.9, 4.0, 4.1),
(3, 4.7, 4.5, 4.6, 4.2, 4.3, 3.8, 4.4, 4.5, 3.2, 4.6),
(4, 4.6, 4.4, 4.5, 4.1, 4.2, 3.9, 4.3, 4.4, 3.3, 4.5),
(5, 4.8, 4.6, 4.7, 4.3, 4.4, 3.7, 4.5, 4.6, 3.1, 4.7),
(6, 4.1, 4.2, 4.0, 4.4, 4.2, 4.4, 4.1, 3.7, 4.3, 4.0),
(7, 4.5, 4.3, 4.4, 4.5, 4.6, 4.0, 4.4, 4.2, 3.0, 4.6),
(8, 4.0, 4.6, 3.9, 4.1, 4.0, 4.3, 4.0, 4.7, 3.8, 4.2),
(9, 4.4, 4.1, 4.3, 4.0, 3.9, 4.1, 4.2, 4.3, 3.6, 4.3),
(10, 3.9, 4.0, 3.8, 3.9, 3.8, 4.2, 3.9, 3.6, 4.2, 3.9);

INSERT INTO vendor_scores (vendor_id, risk_management, compliance_management, audit_incident_management, workflow_automation, integration_apis, ease_of_use, monitoring_dashboards, vendor_third_party_risk, pricing_value, scalability_support) VALUES
-- Workiva
(11, 4.4, 4.7, 4.5, 4.4, 4.3, 4.2, 4.3, 4.0, 3.5, 4.3),
-- SAP GRC
(12, 4.6, 4.5, 4.4, 4.1, 4.2, 3.8, 4.2, 4.4, 3.2, 4.5),
-- Oracle Risk Management and Compliance
(13, 4.5, 4.4, 4.3, 4.0, 4.1, 3.7, 4.1, 4.3, 3.3, 4.4),
-- AuditBoard
(14, 4.2, 4.3, 4.6, 4.5, 4.4, 4.5, 4.3, 4.1, 4.1, 4.2),
-- Riskonnect
(15, 4.3, 4.2, 4.1, 4.0, 4.1, 4.0, 4.2, 4.5, 3.8, 4.3),
-- LogicManager
(16, 4.1, 4.2, 4.0, 4.2, 4.0, 4.3, 4.1, 4.2, 4.0, 4.1),
-- Onspring
(17, 4.0, 4.1, 4.0, 4.3, 4.1, 4.4, 4.0, 4.1, 4.1, 4.2),
-- ZenGRC
(18, 4.0, 4.2, 4.1, 4.2, 3.9, 4.5, 4.0, 4.3, 4.0, 4.1),
-- Convercent
(19, 3.9, 4.0, 4.2, 4.0, 3.8, 4.1, 3.9, 3.9, 4.2, 4.0),
-- TraceSecurity
(20, 4.0, 3.9, 3.8, 3.9, 3.7, 4.0, 3.8, 3.8, 4.1, 3.9),
-- Lepide
(21, 3.8, 3.9, 3.8, 3.7, 3.9, 4.0, 3.8, 3.7, 3.6, 3.8);

-- Add smaller-vendor scores
INSERT INTO vendor_scores (vendor_id, risk_management, compliance_management, audit_incident_management, workflow_automation, integration_apis, ease_of_use, monitoring_dashboards, vendor_third_party_risk, pricing_value, scalability_support) VALUES
-- Apptega
(22, 4.1, 4.3, 4.0, 4.2, 4.1, 4.2, 4.0, 4.0, 4.5, 4.0),
-- StandardFusion
(23, 3.9, 4.0, 3.8, 3.9, 3.8, 4.3, 3.8, 3.9, 4.4, 3.8),
-- Hyperproof
(24, 4.2, 4.1, 4.3, 4.2, 4.0, 4.0, 4.1, 3.9, 4.2, 3.9),
-- Sprinto
(25, 4.3, 4.4, 4.1, 4.3, 4.2, 4.1, 4.2, 3.8, 4.3, 4.0),
-- ControlMap
(26, 3.8, 4.0, 3.7, 3.9, 3.7, 4.0, 3.6, 3.9, 4.6, 3.7),
-- Parapet
(27, 3.7, 3.8, 3.5, 3.6, 3.5, 3.9, 3.5, 3.7, 4.7, 3.6),
-- intelliGRC
(28, 3.9, 3.9, 3.8, 4.0, 3.8, 4.0, 3.7, 3.8, 4.5, 3.8),
-- CISO Assistant
(29, 3.6, 3.7, 3.5, 3.8, 3.6, 4.1, 3.5, 3.6, 4.8, 3.5),
-- Eramba
(30, 3.8, 3.9, 3.7, 3.8, 3.7, 3.8, 3.6, 3.8, 4.9, 3.7),
-- Panorays
(31, 3.9, 3.8, 3.9, 3.7, 4.0, 4.0, 4.0, 4.4, 4.0, 3.9);

INSERT INTO vendor_scores (vendor_id, risk_management, compliance_management, audit_incident_management, workflow_automation, integration_apis, ease_of_use, monitoring_dashboards, vendor_third_party_risk, pricing_value, scalability_support) VALUES
-- Cyber Sierra
(32, 4.4, 4.5, 4.3, 4.4, 4.2, 4.1, 4.3, 4.5, 3.4, 4.2);

INSERT INTO vendor_scores (vendor_id, risk_management, compliance_management, audit_incident_management, workflow_automation, integration_apis, ease_of_use, monitoring_dashboards, vendor_third_party_risk, pricing_value, scalability_support) VALUES
-- 1. Scrut Automation (ID to be auto-assigned, assume sequential 33)
(33, 4.2, 4.3, 4.1, 4.2, 4.1, 4.5, 4.2, 4.0, 4.2, 4.0),

-- 2. Thoropass (34)
(34, 4.1, 4.0, 4.2, 4.1, 4.0, 4.2, 4.1, 3.8, 4.0, 3.9),

-- 3. Diligent HighBond (35)
(35, 4.0, 4.1, 4.0, 4.0, 3.8, 3.9, 4.0, 3.9, 3.5, 3.8),

-- 4. SAI360 (36)
(36, 4.0, 3.9, 4.0, 3.8, 3.9, 3.8, 3.9, 4.1, 3.7, 3.8),

-- 5. Fusion Framework System (37)
(37, 3.9, 3.8, 3.7, 3.9, 3.6, 3.8, 3.7, 3.6, 3.6, 3.7),

-- 6. Mitratech Alyne (38)
(38, 4.1, 4.2, 4.0, 4.1, 4.0, 4.1, 4.0, 3.9, 3.8, 4.0),

-- 7. Enablon (39)
(39, 3.8, 3.9, 3.8, 3.7, 3.6, 3.7, 3.6, 3.8, 3.4, 3.7),

-- 8. TeamMate+ (40)
(40, 3.9, 4.0, 4.3, 3.8, 3.7, 3.8, 4.0, 3.6, 3.4, 3.8),

-- 9. risk3sixty (41)
(41, 4.1, 4.0, 4.0, 4.1, 4.0, 4.2, 4.0, 3.9, 3.8, 4.0),

-- 10. Pathlock (Control-Self-Service) (42)
(42, 3.8, 3.7, 3.8, 3.6, 3.7, 3.8, 3.5, 3.7, 3.5, 3.6),

-- 11. Secureframe (43)
(43, 4.0, 4.1, 4.0, 4.0, 4.0, 4.2, 4.0, 3.9, 3.8, 4.0),

-- 12. MEGA HOPEX (44)
(44, 4.0, 4.1, 4.0, 3.9, 3.8, 3.7, 3.9, 3.8, 3.5, 3.9),

-- 13. TrustArc (45)
(45, 3.8, 3.9, 3.8, 3.7, 3.8, 3.7, 3.7, 3.8, 3.6, 3.7),

-- 14. IsoMetrix (46)
(46, 3.7, 3.8, 3.7, 3.7, 3.6, 3.7, 3.6, 3.7, 3.5, 3.6),

-- 15. Quantivate (47)
(47, 3.8, 3.9, 3.8, 3.8, 3.7, 3.8, 3.7, 3.8, 3.6, 3.7),

-- 16. NAVEX Global (48)
(48, 3.9, 4.0, 4.0, 3.9, 3.8, 3.9, 3.8, 3.9, 3.7, 3.8),

-- 17. SimpleRisk (49)
(49, 3.6, 3.7, 3.6, 3.6, 3.6, 3.7, 3.5, 3.6, 3.8, 3.5),

-- 18. GBTEC (50)
(50, 3.8, 3.9, 3.7, 3.8, 3.6, 3.7, 3.8, 3.6, 3.5, 3.7);


-- Insert sample reviews
INSERT INTO reviews (vendor_id, reviewer_name, review_text, user_rating, is_approved) VALUES
(1, 'Sarah Chen', 'Vanta made our SOC 2 compliance process incredibly smooth. The automated evidence collection saved us weeks of work.', 4.5, true),
(1, 'Mike Rodriguez', 'Great platform but can be pricey for smaller companies. The integrations work well with our existing tools.', 4.0, true),
(2, 'Emily Johnson', 'Drata''s continuous monitoring is fantastic. The dashboard gives us real-time visibility into our compliance posture.', 4.8, true),
(3, 'David Park', 'RSA Archer is powerful but has a steep learning curve. Once configured properly, it handles complex risk scenarios well.', 3.8, true),
(4, 'Lisa Thompson', 'MetricStream offers comprehensive GRC capabilities. The reporting features are particularly strong for enterprise needs.', 4.2, true),
(5, 'James Wilson', 'IBM OpenPages integrates well with other IBM products. The AI features are helpful for risk prediction and analysis.', 4.1, true);

-- Create indexes for better performance
CREATE INDEX idx_vendor_scores_vendor_id ON vendor_scores(vendor_id);
CREATE INDEX idx_reviews_vendor_id ON reviews(vendor_id);
CREATE INDEX idx_reviews_approved ON reviews(is_approved);
CREATE INDEX idx_vendor_scores_overall_score ON vendor_scores(overall_score DESC);

--UPDATE vendors
--SET logo_url = 'https://media.licdn.com/dms/image/v2/D4E33AQGL1WRgoDs9nw/productpage-logo-image_200_200/productpage-logo-image_200_200/0/1711223887458/intuitem_ciso_assistant_logo?e=1757376000&v=beta&t=HtykvvOepik2bck1XRR3Vc2I6D8d7FKmAuGkFt-ILNM' WHERE name = 'CISO Assistant';

-- psql -d grc_rating_db -U postgres -f C:\Users\anvir\PycharmProjects\grc-rating-app2\server\database.sql
