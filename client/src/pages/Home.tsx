import { useQuery } from '@tanstack/react-query';
import { Search, TrendingUp, Shield, Award } from 'lucide-react';
import { vendorApi } from '@/lib/api';
import { VendorCard } from '@/components/VendorCard';
import { Button } from '@/components/ui/button';
import { Link } from 'react-router-dom';

export default function Home() {
  const { data: topVendors = [], isLoading } = useQuery({
    queryKey: ['top-vendors'],
    queryFn: () => vendorApi.getTopVendors().then(res => res.data),
  });

  return (
    <div className="min-h-screen bg-background">
      {/* Hero Section */}
      <section className="relative overflow-hidden bg-gradient-hero py-20">
        <div className="container mx-auto px-4">
          <div className="max-w-4xl mx-auto text-center">
            <h1 className="text-5xl font-bold text-white mb-6 animate-fade-in-up">
              Find the Best GRC Solutions
            </h1>
            <p className="text-xl text-white/90 mb-8 animate-fade-in-up">
              Compare and discover top-rated Governance, Risk & Compliance platforms
              with expert reviews and real user feedback.
            </p>
            <div className="flex flex-col sm:flex-row gap-4 justify-center animate-fade-in-up">
              <Button asChild size="lg" className="bg-white text-primary hover:bg-white/90">
                <Link to="/vendors">
                  <Search className="mr-2 w-5 h-5" />
                  Browse All Vendors
                </Link>
              </Button>
              <Button
                asChild
                variant="outline"
                size="lg"
                className="bg-blue-600 border-blue-600 text-white hover:bg-white/10"
              >
                <Link to="/scoring-criteria">
                  View Scoring Criteria
                </Link>
              </Button>
            </div>
          </div>
        </div>
      </section>

      {/* Top Vendors Section */}
      <section className="py-16 bg-secondary/30">
        <div className="container mx-auto px-4">
          <div className="text-center mb-12">
            <h2 className="text-3xl font-bold mb-4">Top-Rated GRC Platforms</h2>
            <p className="text-muted-foreground text-lg">
              Discover the highest-scoring solutions in our comprehensive evaluation
            </p>
          </div>

          {isLoading ? (
            <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
              {Array.from({ length: 6 }).map((_, i) => (
                <div key={i} className="vendor-card animate-pulse">
                  <div className="h-20 bg-muted rounded mb-4"></div>
                  <div className="h-4 bg-muted rounded mb-2"></div>
                  <div className="h-4 bg-muted rounded w-3/4"></div>
                </div>
              ))}
            </div>
          ) : (
            <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6 mb-8">
              {topVendors.map((vendor) => (
                <VendorCard key={vendor.id} vendor={vendor} />
              ))}
            </div>
          )}

          <div className="text-center">
            <Button asChild variant="outline" size="lg">
              <Link to="/vendors">View All Vendors</Link>
            </Button>
          </div>
        </div>
      </section>

      {/* Features Section
      <section className="py-16 bg-white">
        <div className="container mx-auto px-4">
          <h2 className="text-3xl font-bold text-center mb-12">
            Why Choose Our Platform?
          </h2>
          <div className="grid md:grid-cols-3 gap-8">
            <div className="text-center">
              <div className="w-16 h-16 bg-primary/10 rounded-lg flex items-center justify-center mx-auto mb-4">
                <Shield className="w-8 h-8 text-primary" />
              </div>
              <h3 className="text-xl font-semibold mb-3">Expert Analysis</h3>
              <p className="text-muted-foreground">
                In-depth evaluation across 10 key criteria by GRC specialists
              </p>
            </div>
            <div className="text-center">
              <div className="w-16 h-16 bg-primary/10 rounded-lg flex items-center justify-center mx-auto mb-4">
                <TrendingUp className="w-8 h-8 text-primary" />
              </div>
              <h3 className="text-xl font-semibold mb-3">Real User Reviews</h3>
              <p className="text-muted-foreground">
                Authentic feedback from professionals using these platforms daily
              </p>
            </div>
            <div className="text-center">
              <div className="w-16 h-16 bg-primary/10 rounded-lg flex items-center justify-center mx-auto mb-4">
                <Award className="w-8 h-8 text-primary" />
              </div>
              <h3 className="text-xl font-semibold mb-3">Transparent Scoring</h3>
              <p className="text-muted-foreground">
                Clear methodology and criteria for fair, unbiased comparisons
              </p>
            </div>
          </div>
        </div>
      </section>
      */}
    </div>
  );
}
