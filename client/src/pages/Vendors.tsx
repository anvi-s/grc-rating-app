import { useState, useMemo } from 'react';
import { useQuery } from '@tanstack/react-query';
import { Filter, Home } from 'lucide-react';
import { Link } from 'react-router-dom';
import { vendorApi, Vendor } from '@/lib/api';
import { VendorCard } from '@/components/VendorCard';
import { SearchBar } from '@/components/SearchBar';
import { SortSelect, SortOption } from '@/components/SortSelect';
import { Button } from '@/components/ui/button';

export default function Vendors() {
  const [searchTerm, setSearchTerm] = useState('');
  const [sortBy, setSortBy] = useState<SortOption>('overall_score');

  const { data: vendors = [], isLoading, error } = useQuery({
    queryKey: ['vendors'],
    queryFn: () => vendorApi.getAllVendors().then(res => res.data),
  });

  const filteredAndSortedVendors = useMemo(() => {
    let filtered = vendors.filter((vendor: Vendor) =>
      vendor.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
      (vendor.summary && vendor.summary.toLowerCase().includes(searchTerm.toLowerCase()))
    );

    return filtered.sort((a: Vendor, b: Vendor) => {
      switch (sortBy) {
        case 'overall_score':
          return (b.overall_score || 0) - (a.overall_score || 0);
        case 'avg_user_rating':
          return b.avg_user_rating - a.avg_user_rating;
        case 'review_count':
          return b.review_count - a.review_count;
        case 'name':
          return a.name.localeCompare(b.name);
        case 'founded_year':
          return (b.founded_year || 0) - (a.founded_year || 0);
        default:
          return 0;
      }
    });
  }, [vendors, searchTerm, sortBy]);

  if (error) {
    return (
      <div className="min-h-screen bg-background flex items-center justify-center">
        <div className="text-center">
          <h2 className="text-2xl font-bold mb-4">Unable to Load Vendors</h2>
          <p className="text-muted-foreground mb-4">
            Please make sure your backend API is running on localhost:5000
          </p>
          <Button onClick={() => window.location.reload()}>
            Try Again
          </Button>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-background">
      {/* Header */}
      <div className="bg-gradient-hero py-12 relative">
        <div className="container mx-auto px-4">
          <Link
            to="/"
            className="absolute top-6 left-6 inline-flex items-center gap-2 px-4 py-2 bg-white/10 text-white hover:bg-white/20 rounded-lg transition-colors z-10"
          >
            <Home className="w-4 h-4" />
            Home
          </Link>
          <h1 className="text-4xl font-bold text-white text-center mb-4">
            GRC Vendor Directory
          </h1>
          <p className="text-white/90 text-center text-lg">
            Compare {vendors.length} governance, risk, and compliance solutions
          </p>
        </div>
      </div>

      {/* Search and Filter Section */}
      <div className="bg-white border-b border-border">
        <div className="container mx-auto px-4 py-6">
          <div className="flex flex-col md:flex-row gap-4 items-center justify-between">
            <SearchBar
              value={searchTerm}
              onChange={setSearchTerm}
              placeholder="Search by vendor name or description..."
              className="w-full md:w-96"
            />
            <div className="flex items-center gap-4">
              <SortSelect value={sortBy} onChange={setSortBy} />
            </div>
          </div>
        </div>
      </div>

      {/* Results Section */}
      <div className="container mx-auto px-4 py-8">
        <div className="mb-6">
          <p className="text-muted-foreground">
            Showing {filteredAndSortedVendors.length} of {vendors.length} vendors
            {searchTerm && ` for "${searchTerm}"`}
          </p>
        </div>

        {isLoading ? (
          <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
            {Array.from({ length: 9 }).map((_, i) => (
              <div key={i} className="vendor-card animate-pulse">
                <div className="h-20 bg-muted rounded mb-4"></div>
                <div className="h-4 bg-muted rounded mb-2"></div>
                <div className="h-4 bg-muted rounded w-3/4 mb-4"></div>
                <div className="h-8 bg-muted rounded"></div>
              </div>
            ))}
          </div>
        ) : filteredAndSortedVendors.length === 0 ? (
          <div className="text-center py-12">
            <h3 className="text-xl font-semibold mb-2">No vendors found</h3>
            <p className="text-muted-foreground">
              Try adjusting your search criteria or filters
            </p>
          </div>
        ) : (
          <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
            {filteredAndSortedVendors.map((vendor) => (
              <VendorCard key={vendor.id} vendor={vendor} />
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
