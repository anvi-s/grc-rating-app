import { Star } from 'lucide-react';

interface StarRatingProps {
  rating: number | string;
  maxRating?: number;
  size?: 'sm' | 'md' | 'lg';
  showNumber?: boolean;
  className?: string;
}

export const StarRating = ({
  rating,
  maxRating = 5,
  size = 'md',
  showNumber = false,
  className = ''
}: StarRatingProps) => {
  const sizeClasses = {
    sm: 'w-3 h-3',
    md: 'w-4 h-4',
    lg: 'w-5 h-5'
  };

  // Ensure rating is a valid number and handle null/undefined values
  const safeRating = (() => {
    if (typeof rating === 'number' && !isNaN(rating)) return rating;
    if (typeof rating === 'string') {
      const parsed = parseFloat(rating);
      return !isNaN(parsed) ? parsed : 0;
    }
    return 0;
  })();
  const fullStars = Math.floor(safeRating);
  const hasHalfStar = safeRating % 1 >= 0.5;

  return (
    <div className={`star-rating ${className}`}>
      {Array.from({ length: maxRating }).map((_, index) => {
        const isFilled = index < fullStars;
        const isHalf = index === fullStars && hasHalfStar;

        return (
          <div key={index} className="relative">
            <Star
              className={`${sizeClasses[size]} ${
                isFilled ? 'star-filled' : isHalf ? 'star-half' : 'star-empty'
              }`}
              fill={isFilled ? 'currentColor' : 'none'}
            />
            {isHalf && (
              <Star
                className={`${sizeClasses[size]} star-filled absolute top-0 left-0`}
                fill="currentColor"
                style={{
                  clipPath: 'polygon(0 0, 50% 0, 50% 100%, 0 100%)'
                }}
              />
            )}
          </div>
        );
      })}
      {showNumber && (
        <span className="ml-1 text-sm font-medium text-muted-foreground">
          {safeRating.toFixed(1)}
        </span>
      )}
    </div>
  );
};
