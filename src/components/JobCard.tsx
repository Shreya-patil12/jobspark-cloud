import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { MapPin, Briefcase, DollarSign } from "lucide-react";
import { useNavigate } from "react-router-dom";

interface JobCardProps {
  id: string;
  title: string;
  category: string;
  location: string;
  jobType: string;
  description: string;
  salaryRange?: string;
}

export const JobCard = ({ id, title, category, location, jobType, description, salaryRange }: JobCardProps) => {
  const navigate = useNavigate();

  return (
    <Card 
      className="group cursor-pointer transition-all duration-300 hover:shadow-hover border-border/50 bg-gradient-card"
      onClick={() => navigate(`/jobs/${id}`)}
    >
      <CardHeader>
        <div className="flex items-start justify-between gap-4">
          <div className="flex-1">
            <CardTitle className="text-xl mb-2 group-hover:text-primary transition-colors">
              {title}
            </CardTitle>
            <CardDescription className="flex flex-wrap gap-2 items-center text-sm">
              <Badge variant="secondary" className="bg-primary/10 text-primary font-medium">
                {category}
              </Badge>
              <Badge variant="outline">{jobType}</Badge>
            </CardDescription>
          </div>
        </div>
      </CardHeader>
      <CardContent>
        <p className="text-muted-foreground mb-4 line-clamp-2">{description}</p>
        <div className="flex flex-col gap-2 text-sm text-muted-foreground">
          <div className="flex items-center gap-2">
            <MapPin className="w-4 h-4" />
            <span>{location}</span>
          </div>
          {salaryRange && (
            <div className="flex items-center gap-2">
              <DollarSign className="w-4 h-4" />
              <span>{salaryRange}</span>
            </div>
          )}
        </div>
        <Button className="w-full mt-4 bg-primary hover:bg-primary/90" onClick={(e) => {
          e.stopPropagation();
          navigate(`/jobs/${id}`);
        }}>
          View Details
        </Button>
      </CardContent>
    </Card>
  );
};
