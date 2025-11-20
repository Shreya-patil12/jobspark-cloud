-- Create enum for job categories
CREATE TYPE public.job_category AS ENUM ('PaaS', 'SaaS', 'IaaS', 'FaaS', 'DaaS', 'BaaS');

-- Create enum for job types
CREATE TYPE public.job_type AS ENUM ('Full-time', 'Part-time', 'Contract', 'Remote');

-- Create jobs table
CREATE TABLE public.jobs (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  category public.job_category NOT NULL,
  location TEXT NOT NULL,
  job_type public.job_type NOT NULL,
  description TEXT NOT NULL,
  requirements TEXT NOT NULL,
  salary_range TEXT,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Create applications table
CREATE TABLE public.applications (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  job_id UUID NOT NULL REFERENCES public.jobs(id) ON DELETE CASCADE,
  full_name TEXT NOT NULL,
  email TEXT NOT NULL,
  phone TEXT NOT NULL,
  resume_url TEXT,
  cover_letter TEXT NOT NULL,
  linkedin_url TEXT,
  portfolio_url TEXT,
  years_experience INTEGER,
  status TEXT NOT NULL DEFAULT 'pending',
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE public.jobs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.applications ENABLE ROW LEVEL SECURITY;

-- Create policies for jobs (publicly readable)
CREATE POLICY "Jobs are viewable by everyone" 
ON public.jobs 
FOR SELECT 
USING (true);

-- Create policy for applications (anyone can insert)
CREATE POLICY "Anyone can submit applications" 
ON public.applications 
FOR INSERT 
WITH CHECK (true);

-- Create function to update timestamps
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SET search_path = public;

-- Create trigger for automatic timestamp updates on jobs
CREATE TRIGGER update_jobs_updated_at
BEFORE UPDATE ON public.jobs
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();

-- Insert sample jobs
INSERT INTO public.jobs (title, category, location, job_type, description, requirements, salary_range) VALUES
('Senior PaaS Engineer', 'PaaS', 'San Francisco, CA', 'Full-time', 
 'Lead the development of our Platform-as-a-Service infrastructure. Build and maintain scalable cloud platforms that enable developers to deploy applications effortlessly.',
 'Experience with Kubernetes, Docker, CI/CD pipelines, Cloud infrastructure (AWS/GCP/Azure), 5+ years in platform engineering',
 '$150,000 - $200,000'),
 
('SaaS Product Manager', 'SaaS', 'New York, NY', 'Full-time',
 'Drive product strategy for our SaaS offerings. Work with engineering and design teams to deliver exceptional cloud-based solutions.',
 'Product management experience in SaaS, Strong understanding of cloud technologies, Excellent communication skills, 3+ years experience',
 '$120,000 - $160,000'),
 
('Infrastructure Architect (IaaS)', 'IaaS', 'Austin, TX', 'Remote',
 'Design and implement infrastructure solutions for enterprise clients. Focus on scalability, security, and cost optimization.',
 'Deep knowledge of cloud infrastructure, Experience with AWS/Azure/GCP, Infrastructure as Code (Terraform/CloudFormation), 7+ years experience',
 '$140,000 - $190,000'),
 
('Cloud Functions Developer', 'FaaS', 'Seattle, WA', 'Contract',
 'Build serverless applications using cloud functions. Optimize performance and cost for event-driven architectures.',
 'Experience with AWS Lambda, Google Cloud Functions, or Azure Functions, Node.js/Python proficiency, 3+ years serverless experience',
 '$100,000 - $130,000'),
 
('Data Platform Engineer', 'DaaS', 'Boston, MA', 'Full-time',
 'Build and maintain our Data-as-a-Service platform. Enable seamless data access and analytics for enterprise customers.',
 'Experience with data warehouses, ETL pipelines, SQL/NoSQL databases, Data modeling expertise, 4+ years in data engineering',
 '$130,000 - $170,000'),
 
('Backend-as-a-Service Developer', 'BaaS', 'Remote', 'Remote',
 'Develop backend services and APIs for mobile and web applications. Focus on scalability and developer experience.',
 'Backend development experience, RESTful API design, Database expertise, Experience with Firebase/Supabase/AWS Amplify, 3+ years experience',
 '$110,000 - $150,000');