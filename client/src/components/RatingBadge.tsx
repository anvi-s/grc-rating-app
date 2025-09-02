interface RatingBadgeProps {
  score: number;
  className?: string;
}

export const RatingBadge = ({ score, className = '' }: RatingBadgeProps) => {
  const getRatingClass = (score: number) => {
    if (score >= 4.3) return 'rating-excellent';
    if (score >= 4) return 'rating-good';
    if (score >= 3.7) return 'rating-average';
    return 'rating-poor';
  };

  const getRatingLabel = (score: number) => {
    if (score >= 4.3) return 'Excellent';
    if (score >= 4) return 'Good';
    if (score >= 3.7) return 'Average';
    return 'Below Average';
  };

  return (
    <span className={`rating-badge ${getRatingClass(score)} ${className}`}>
      {getRatingLabel(score)} ({score}/5)
    </span>
  );
};
