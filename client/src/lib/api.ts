import axios from 'axios';

const API_BASE_URL = 'http://localhost:5000';

export const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json; charset=utf-8',
    'Accept': 'application/json; charset=utf-8',
  },
});

export interface Vendor {
  id: number;
  name: string;
  logo_url?: string;
  summary?: string;
  website_url?: string;
  website?: string; // Keep for backwards compatibility
  pricing_estimate?: string;
  founded_year?: number;
  overall_score?: number | null;
  star_rating?: number | null;
  risk_management?: number | null;
  compliance_management?: number | null;
  audit_incident_management?: number | null;
  workflow_automation?: number | null;
  integration_apis?: number | null;
  ease_of_use?: number | null;
  monitoring_dashboards?: number | null;
  vendor_third_party_risk?: number | null;
  pricing_value?: number | null;
  scalability_support?: number | null;
  avg_user_rating: number | null;
  review_count: number;
  reviews?: Review[];
}

export interface Review {
  id: number;
  reviewer_name: string;
  review_text: string;
  user_rating: number;
  created_at: string;
}

export interface ScoringCriteria {
  key: string;
  name: string;
  weight: number;
}

export const vendorApi = {
  getAllVendors: () => api.get<Vendor[]>('/vendors'),
  getVendorById: (id: number) => api.get<Vendor>(`/vendors/${id}`),
  getTopVendors: () => api.get<Vendor[]>('/top-vendors'),
  submitReview: (review: {
    vendor_id: number;
    reviewer_name?: string;
    review_text: string;
    user_rating: number;
  }) => api.post('/reviews', review),
  getScoringCriteria: () => api.get<ScoringCriteria[]>('/criteria'),
};
