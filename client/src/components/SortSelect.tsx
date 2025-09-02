import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";

export type SortOption =
  | 'overall_score'
  | 'avg_user_rating'
  | 'review_count'
  | 'name';

interface SortSelectProps {
  value: SortOption;
  onChange: (value: SortOption) => void;
  className?: string;
}

const sortOptions: { value: SortOption; label: string }[] = [
  { value: 'overall_score', label: 'Overall Score' },
  { value: 'avg_user_rating', label: 'User Rating' },
  { value: 'review_count', label: 'Most Reviewed' },
  { value: 'name', label: 'Name (A-Z)' },
];

export const SortSelect = ({ value, onChange, className = "" }: SortSelectProps) => {
  return (
    <Select value={value} onValueChange={onChange}>
      <SelectTrigger className={`w-[180px] bg-white ${className}`}>
        <SelectValue placeholder="Sort by..." />
      </SelectTrigger>
      <SelectContent>
        {sortOptions.map((option) => (
          <SelectItem key={option.value} value={option.value}>
            {option.label}
          </SelectItem>
        ))}
      </SelectContent>
    </Select>
  );
};
