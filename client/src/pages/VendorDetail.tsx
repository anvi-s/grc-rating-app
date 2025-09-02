import { useState } from 'react';
import { useParams, Link } from 'react-router-dom';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { ArrowLeft, ExternalLink, Calendar, Users, Star } from 'lucide-react';
import { vendorApi } from '@/lib/api';
import { StarRating } from '@/components/StarRating';
import { RatingBadge } from '@/components/RatingBadge';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Textarea } from '@/components/ui/textarea';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { toast } from '@/hooks/use-toast';

export default function VendorDetail() {
  const { id } = useParams<{ id: string }>();

  const queryClient = useQueryClient();
  const [reviewForm, setReviewForm] = useState({
    reviewer_name: '',
    review_text: '',
    user_rating: 5
  });

  const { data: vendor, isLoading, error } = useQuery({
    queryKey: ['vendor', id],
    queryFn: () => vendorApi.getVendorById(Number(id)).then(res => res.data),
    enabled: !!id,
  });

  const submitReviewMutation = useMutation({
    mutationFn: (reviewData: typeof reviewForm) =>
      vendorApi.submitReview({
        vendor_id: Number(id),
        ...reviewData
      }),
    onSuccess: () => {
      toast({
        title: "Review Submitted",
        description: "Your review has been submitted and is pending approval.",
      });
      setReviewForm({ reviewer_name: '', review_text: '', user_rating: 5 });
      queryClient.invalidateQueries({ queryKey: ['vendor', id] });
    },
    onError: () => {
      toast({
        title: "Error",
        description: "Failed to submit review. Please try again.",
        variant: "destructive",
      });
    }
  });

  const handleSubmitReview = (e: React.FormEvent) => {
    e.preventDefault();
    if (!reviewForm.review_text.trim()) {
      toast({
        title: "Error",
        description: "Please enter a review.",
        variant: "destructive",
      });
      return;
    }
    submitReviewMutation.mutate(reviewForm);
  };

  if (isLoading) {
    return (
      <div className="min-h-screen bg-background flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto mb-4"></div>
          <p className="text-muted-foreground">Loading vendor details...</p>
        </div>
      </div>
    );
  }

  if (error || !vendor) {
    return (
      <div className="min-h-screen bg-background flex items-center justify-center">
        <div className="text-center">
          <h2 className="text-2xl font-bold mb-4">Vendor Not Found</h2>
          <p className="text-muted-foreground mb-4">
            The vendor you're looking for doesn't exist or couldn't be loaded.
          </p>
          <Button asChild>
            <Link to="/vendors">Back to Vendors</Link>
          </Button>
        </div>
      </div>
    );
  }

  const criteriaScores = [
    { key: 'risk_management', name: 'Risk Management', score: vendor.risk_management },
    { key: 'compliance_management', name: 'Compliance Management', score: vendor.compliance_management },
    { key: 'audit_incident_management', name: 'Audit & Incident Management', score: vendor.audit_incident_management },
    { key: 'workflow_automation', name: 'Workflow Automation', score: vendor.workflow_automation },
    { key: 'integration_apis', name: 'Integration & APIs', score: vendor.integration_apis },
    { key: 'ease_of_use', name: 'Ease of Use / UI', score: vendor.ease_of_use },
    { key: 'monitoring_dashboards', name: 'Real-time Monitoring & Dashboards', score: vendor.monitoring_dashboards },
    { key: 'vendor_third_party_risk', name: 'Vendor / Third-party Risk', score: vendor.vendor_third_party_risk },
    { key: 'pricing_value', name: 'Pricing & Value', score: vendor.pricing_value },
    { key: 'scalability_support', name: 'Scalability & Support', score: vendor.scalability_support },
  ].filter(criteria => criteria.score !== null && criteria.score !== undefined);

  return (
    <div className="min-h-screen bg-background">
      {/* Header */}
      <div className="bg-white border-b border-border">
        <div className="container mx-auto px-4 py-6">
          <div className="flex items-center gap-4 mb-6">
            <Button variant="ghost" asChild>
              <Link to="/vendors">
                <ArrowLeft className="w-4 h-4 mr-2" />
                Back to Vendors
              </Link>
            </Button>
          </div>

          <div className="flex flex-col lg:flex-row gap-8">
            <div className="flex-1">
              <div className="flex items-start gap-4 mb-6">
                <div className="w-28 h-28 bg-gradient-primary rounded-xl flex items-center justify-center flex-shrink-0">
                  {vendor.logo_url ? (
                    <img
                      src={vendor.logo_url}
                      alt={`${vendor.name} logo`}
                      className="w-24 h-24 object-contain"
                    />
                  ) : (
                    <div className="w-10 h-10 bg-white/20 rounded"></div>
                  )}
                </div>
                <div className="flex-1">
                  {vendor.website_url || vendor.website ? (
                    <a
                      href={vendor.website_url || vendor.website}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="inline-block"
                    >
                      <h1 className="text-3xl font-bold mb-2 hover:text-primary transition-colors cursor-pointer">
                        {vendor.name}
                      </h1>
                    </a>
                  ) : (
                    <h1 className="text-3xl font-bold mb-2">{vendor.name}</h1>
                  )}
                  {vendor.pricing_estimate && (
                    <p className="text-lg text-muted-foreground mb-3">
                      {vendor.pricing_estimate}
                    </p>
                  )}
                  <div className="flex flex-wrap items-center gap-4 text-muted-foreground">
                    {vendor.founded_year && (
                      <div className="flex items-center gap-1">
                        <Calendar className="w-4 h-4" />
                        <span>Founded {vendor.founded_year}</span>
                      </div>
                    )}
                    <div className="flex items-center gap-1">
                      <Users className="w-4 h-4" />
                      <span>{vendor.review_count} reviews</span>
                    </div>
                    {(vendor.website_url || vendor.website) && (
                      <a
                        href={vendor.website_url || vendor.website}
                        target="_blank"
                        rel="noopener noreferrer"
                        className="flex items-center gap-1 text-primary hover:text-primary-glow transition-colors"
                      >
                        <ExternalLink className="w-4 h-4" />
                        Website
                      </a>
                    )}
                  </div>
                </div>
              </div>

              {vendor.summary && (
                <p className="text-muted-foreground text-lg leading-relaxed">
                  {vendor.summary}
                </p>
              )}
            </div>

            <div className="lg:w-80">
              <Card>
                <CardHeader>
                  <CardTitle className="text-center">Overall Rating</CardTitle>
                </CardHeader>
                <CardContent className="text-center">
                  {vendor.overall_score && (
                    <RatingBadge score={vendor.overall_score} className="mb-4" />
                  )}
                  {vendor.star_rating && (
                    <div className="mb-4 flex flex-col items-center">
                      <p className="text-sm text-muted-foreground mb-2">Expert Rating</p>
                      <StarRating rating={vendor.star_rating} size="lg" showNumber />
                    </div>
                  )}
                  <div className="flex flex-col items-center">
                    <p className="text-sm text-muted-foreground mb-2">User Rating</p>
                    <StarRating rating={vendor.avg_user_rating} size="lg" showNumber />
                  </div>
                </CardContent>
              </Card>
            </div>
          </div>
        </div>
      </div>

      <div className="container mx-auto px-4 py-8">
        <div className="grid lg:grid-cols-3 gap-8">
          {/* Main Content */}
          <div className="lg:col-span-2 space-y-8">
            {/* Scoring Breakdown */}
            {criteriaScores.length > 0 && (
              <Card>
                <CardHeader>
                  <CardTitle>Detailed Scoring Breakdown</CardTitle>
                </CardHeader>
                <CardContent>
                  <div className="space-y-4">
                    {criteriaScores.map((criteria) => (
                      <div key={criteria.key} className="flex items-center justify-between">
                        <span className="font-medium">{criteria.name}</span>
                        <div className="flex items-center gap-3">
                          <div className="w-32 bg-muted rounded-full h-2">
                            <div
                              className="bg-primary rounded-full h-2 transition-all"
                              style={{ width: `${criteria.score*20}%` }}
                            />
                          </div>
                          <span className="font-semibold w-12 text-right">
                            {criteria.score}/5
                          </span>
                        </div>
                      </div>
                    ))}
                  </div>
                </CardContent>
              </Card>
            )}

            {/* Reviews */}
            <Card>
              <CardHeader>
                <CardTitle>User Reviews ({vendor.review_count})</CardTitle>
              </CardHeader>
              <CardContent>
                {vendor.reviews && vendor.reviews.length > 0 ? (
                  <div className="space-y-6">
                    {vendor.reviews.map((review) => (
                      <div key={review.id} className="border-b border-border pb-6 last:border-b-0">
                        <div className="flex items-start justify-between mb-3">
                          <div>
                            <h4 className="font-semibold">
                              {review.reviewer_name || 'Anonymous'}
                            </h4>
                            <StarRating rating={review.user_rating} size="sm" />
                          </div>
                          <time className="text-sm text-muted-foreground">
                            {new Date(review.created_at).toLocaleDateString()}
                          </time>
                        </div>
                        <p className="text-muted-foreground leading-relaxed">
                          {review.review_text}
                        </p>
                      </div>
                    ))}
                  </div>
                ) : (
                  <p className="text-muted-foreground text-center py-8">
                    No reviews yet. Be the first to review this vendor!
                  </p>
                )}
              </CardContent>
            </Card>
          </div>

          {/* Sidebar */}
          <div className="space-y-6">
            {/* Write Review */}
            <Card>
              <CardHeader>
                <CardTitle>Write a Review</CardTitle>
              </CardHeader>
              <CardContent>
                <form onSubmit={handleSubmitReview} className="space-y-4">
                  <div>
                    <Label htmlFor="reviewer_name">Name</Label>
                    <Input
                      id="reviewer_name"
                      value={reviewForm.reviewer_name}
                      onChange={(e) => setReviewForm(prev => ({ ...prev, reviewer_name: e.target.value }))}
                      placeholder="Your name"
                    />
                  </div>

                  <div>
                    <Label htmlFor="user_rating">Rating</Label>
                    <div className="flex items-center gap-2 mt-2">
                      {[1, 2, 3, 4, 5].map((rating) => (
                        <div key={rating} className="relative focus:outline-none">
                          {/* Left half of star (0.5) */}
                          <button
                            type="button"
                            onClick={() => setReviewForm(prev => ({ ...prev, user_rating: rating - 0.5 }))}
                            className="absolute left-0 top-0 w-3 h-6 z-10 focus:outline-none"
                            style={{ clipPath: 'polygon(0 0, 50% 0, 50% 100%, 0 100%)' }}
                          />
                          {/* Right half of star (full) */}
                          <button
                            type="button"
                            onClick={() => setReviewForm(prev => ({ ...prev, user_rating: rating }))}
                            className="absolute right-0 top-0 w-3 h-6 z-10 focus:outline-none"
                            style={{ clipPath: 'polygon(50% 0, 100% 0, 100% 100%, 50% 100%)' }}
                          />
                          <Star
                            className={`w-6 h-6 ${
                              rating <= reviewForm.user_rating
                                ? 'text-accent fill-current'
                                : rating - 0.5 <= reviewForm.user_rating
                                ? 'text-accent'
                                : 'text-muted-foreground'
                            }`}
                            fill={rating <= reviewForm.user_rating ? 'currentColor' : 'none'}
                          />
                          {/* Half star overlay */}
                          {rating - 0.5 === reviewForm.user_rating && (
                            <Star
                              className="w-6 h-6 text-accent absolute top-0 left-0"
                              fill="currentColor"
                              style={{
                                clipPath: 'polygon(0 0, 50% 0, 50% 100%, 0 100%)'
                              }}
                            />
                          )}
                        </div>
                      ))}
                      <span className="ml-2 text-sm text-muted-foreground">
                        ({reviewForm.user_rating}/5)
                      </span>
                    </div>
                  </div>

                  <div>
                    <Label htmlFor="review_text">Review</Label>
                    <Textarea
                      id="review_text"
                      value={reviewForm.review_text}
                      onChange={(e) => setReviewForm(prev => ({ ...prev, review_text: e.target.value }))}
                      placeholder="Share your experience with this vendor..."
                      rows={4}
                      required
                    />
                  </div>

                  <Button
                    type="submit"
                    className="w-full"
                    disabled={submitReviewMutation.isPending}
                  >
                    {submitReviewMutation.isPending ? 'Submitting...' : 'Submit Review'}
                  </Button>
                </form>
              </CardContent>
            </Card>
          </div>
        </div>
      </div>
    </div>
  );
}
