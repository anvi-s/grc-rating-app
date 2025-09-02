import { Building2, Users, ExternalLink } from 'lucide-react';
import { StarRating } from './StarRating';
import { RatingBadge } from './RatingBadge';
import { Vendor } from '@/lib/api';
import { Link } from 'react-router-dom';

interface VendorCardProps {
  vendor: Vendor;
  className?: string;
}

export const VendorCard = ({ vendor, className = '' }: VendorCardProps) => {
  return (
    <div className={`vendor-card ${className}`}>
      <div className="flex items-start justify-between mb-4">
        <div className="flex items-center gap-3">
          <div className="w-12 h-12 bg-gradient-primary rounded-lg flex items-center justify-center">
            {vendor.logo_url ? (
              <img
                src={vendor.logo_url}
                alt={`${vendor.name} logo`}
                className="w-8 h-8 object-contain"
              />
            ) : (
              <Building2 className="w-6 h-6 text-white" />
            )}
          </div>
          <div>
            <h3 className="font-semibold text-lg text-foreground">
              {vendor.name}
            </h3>
            {vendor.founded_year && (
              <p className="text-sm text-muted-foreground">
                Founded {vendor.founded_year}
              </p>
            )}
          </div>
        </div>
        {vendor.overall_score && (
          <RatingBadge score={vendor.overall_score} />
        )}
      </div>

      <p className="text-muted-foreground text-sm mb-4 line-clamp-3">
        {vendor.summary || 'No description available.'}
      </p>

      <div className="flex items-center justify-between mb-4">
        <div className="flex items-center gap-4">
          <div className="flex items-center gap-1">
            <StarRating rating={vendor.avg_user_rating} size="sm" />
            <span className="text-sm text-muted-foreground">
              ({vendor.review_count})
            </span>
          </div>
          {vendor.star_rating && (
            <div className="flex items-center gap-1">
              <span className="text-sm font-medium text-foreground">
                Expert:
              </span>
              <StarRating rating={vendor.star_rating} size="sm" />
            </div>
          )}
        </div>
        <div className="flex items-center gap-1 text-muted-foreground">
          <Users className="w-4 h-4" />
          <span className="text-sm">{vendor.review_count} reviews</span>
        </div>
      </div>

      <div className="flex items-center justify-between">
        <Link
          to={`/vendors/${vendor.id}`}
          className="text-primary hover:text-primary-glow font-medium text-sm transition-colors"
          onClick={() => console.log('VendorCard - Clicking vendor:', vendor.id, vendor.name)}
        >
          View Details
        </Link>
        {vendor.website && (
          <a
            href={vendor.website}
            target="_blank"
            rel="noopener noreferrer"
            className="flex items-center gap-1 text-muted-foreground hover:text-primary text-sm transition-colors"
          >
            <ExternalLink className="w-3 h-3" />
            Website
          </a>
        )}
      </div>
    </div>
  );
};
