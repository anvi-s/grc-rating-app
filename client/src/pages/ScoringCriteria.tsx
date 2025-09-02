import { Shield, TrendingUp, Users, DollarSign, Zap, Building, Wrench, Lock, BarChart3, HeadphonesIcon, Home } from 'lucide-react';
import { Link } from 'react-router-dom';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';

const scoringCriteria = [
  {
    icon: Shield,
    name: "Risk Management",
    weight: "15%",
    description: "Comprehensive risk assessment capabilities, threat identification, risk scoring, mitigation planning, and continuous monitoring of organizational risks.",
    factors: ["Risk identification", "Risk scoring & prioritization", "Mitigation planning", "Risk monitoring & tracking"]
  },
  {
    icon: Building,
    name: "Compliance Management",
    weight: "15%",
    description: "Framework support for regulatory compliance, policy management, compliance tracking, and automated compliance reporting across multiple standards.",
    factors: ["Regulatory framework support", "Policy lifecycle management", "Compliance tracking", "Automated reporting"]
  },
  {
    icon: BarChart3,
    name: "Audit & Incident Management",
    weight: "12%",
    description: "Audit planning and execution tools, incident response workflows, evidence collection, and comprehensive audit trail management.",
    factors: ["Audit planning & scheduling", "Incident response workflows", "Evidence management", "Audit trail & documentation"]
  },
  {
    icon: Zap,
    name: "Workflow Automation",
    weight: "10%",
    description: "Automated workflow capabilities, task assignment, approval processes, notification systems, and streamlined GRC operations.",
    factors: ["Automated task assignment", "Approval workflows", "Notification systems", "Process automation"]
  },
  {
    icon: Zap,
    name: "Ease of Use",
    weight: "10%",
    description: "User interface design, learning curve, workflow efficiency, intuitive navigation, and overall user experience quality.",
    factors: ["Intuitive interface", "Learning curve", "Workflow efficiency", "Mobile accessibility"]
  },
  {
    icon: TrendingUp,
    name: "Scalability & Support",
    weight: "10%",
    description: "Platform's ability to scale with organization growth, performance at scale, customer support quality, and enterprise-grade capabilities.",
    factors: ["Performance scalability", "User capacity", "Support quality", "Enterprise features"]
  },
  {
    icon: Wrench,
    name: "Integration & APIs",
    weight: "8%",
    description: "API availability, third-party integrations, data import/export capabilities, and ecosystem connectivity with existing tools.",
    factors: ["API quality & documentation", "Third-party connectors", "Data migration tools", "System integrations"]
  },
  {
    icon: BarChart3,
    name: "Monitoring & Dashboards",
    weight: "7%",
    description: "Real-time monitoring capabilities, customizable dashboards, KPI tracking, and comprehensive visualization of GRC metrics.",
    factors: ["Real-time monitoring", "Custom dashboards", "KPI tracking", "Data visualization"]
  },
  {
    icon: Users,
    name: "Vendor & Third-Party Risk",
    weight: "7%",
    description: "Third-party risk assessment tools, vendor evaluation capabilities, supply chain risk management, and external partner monitoring.",
    factors: ["Vendor risk assessment", "Supply chain monitoring", "Third-party evaluation", "Partner risk tracking"]
  },
  {
    icon: DollarSign,
    name: "Pricing & Value",
    weight: "6%",
    description: "Pricing transparency, cost-effectiveness, ROI potential, total cost of ownership, and overall value proposition assessment.",
    factors: ["Pricing transparency", "Cost per user", "ROI potential", "Total cost of ownership"]
  }
];

export default function ScoringCriteria() {
  return (
    <div className="min-h-screen bg-background">
      {/* Hero Section */}
      <section className="bg-gradient-hero py-16 relative">
        <Link
          to="/"
          className="absolute top-4 left-4 inline-flex items-center gap-2 px-4 py-2 bg-white/10 text-white hover:bg-white/20 rounded-lg transition-colors z-10"
        >
          <Home className="w-4 h-4" />
          Home
        </Link>
        <div className="container mx-auto px-4">
          <div className="max-w-4xl mx-auto text-center">
            <h1 className="text-4xl font-bold text-white mb-6">
              Our Scoring Methodology
            </h1>
            <p className="text-xl text-white/90 mb-8">
              Transparent, comprehensive evaluation criteria designed by GRC experts to help you make informed decisions.
            </p>
          </div>
        </div>
      </section>

      {/* Scoring Overview */}
      <section className="py-16 bg-white">
        <div className="container mx-auto px-4">
          <div className="max-w-4xl mx-auto">
            <div className="text-center mb-12">
              <h2 className="text-3xl font-bold mb-4">How We Evaluate GRC Platforms</h2>
              <p className="text-lg text-muted-foreground">
                Each platform is scored across 10 key criteria, with weighted scores contributing to an overall rating out of 5 points. Each catgeory can be loosely classified as high priority (≥ 12%), medium priority (8-10%), and low priority (&lt;7%). Categories were compared to decide how critical each factor is to the core function of GRC tools, as well as how commonly they are cited as priorities by real-world users (compliance officers, risk managers, IT security leads, etc.).
              </p>
            </div>

            <div className="grid gap-6 mb-12">
              {scoringCriteria.map((criteria, index) => {
                const Icon = criteria.icon;
                return (
                  <Card key={index} className="hover:shadow-lg transition-shadow">
                    <CardHeader>
                      <div className="flex items-start gap-4">
                        <div className="w-12 h-12 bg-primary/10 rounded-lg flex items-center justify-center flex-shrink-0">
                          <Icon className="w-6 h-6 text-primary" />
                        </div>
                        <div className="flex-1">
                          <div className="flex items-center gap-3 mb-2">
                            <CardTitle className="text-xl">{criteria.name}</CardTitle>
                            <Badge variant="secondary">{criteria.weight}</Badge>
                          </div>
                          <CardDescription className="text-base">
                            {criteria.description}
                          </CardDescription>
                        </div>
                      </div>
                    </CardHeader>
                    <CardContent>
                      <div className="grid sm:grid-cols-2 gap-2">
                        {criteria.factors.map((factor, factorIndex) => (
                          <div key={factorIndex} className="flex items-center gap-2">
                            <div className="w-2 h-2 bg-primary rounded-full"></div>
                            <span className="text-sm text-muted-foreground">{factor}</span>
                          </div>
                        ))}
                      </div>
                    </CardContent>
                  </Card>
                );
              })}
            </div>

            {/* Additional Information */}
            <Card className="bg-secondary/30">
              <CardHeader>
                <CardTitle>Scoring Process</CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="grid md:grid-cols-2 gap-6">
                  <div>
                    <h4 className="font-semibold mb-2">Expert Review</h4>
                    <p className="text-sm text-muted-foreground">
                      Our team of GRC specialists conducts hands-on testing and evaluation of each platform's capabilities.
                    </p>
                  </div>
                  <div>
                    <h4 className="font-semibold mb-2">User Feedback</h4>
                    <p className="text-sm text-muted-foreground">
                      Real user reviews and ratings are collected and analyzed to provide authentic insights into platform performance.
                    </p>
                  </div>
                  <div>
                    <h4 className="font-semibold mb-2">Vendor Assessment</h4>
                    <p className="text-sm text-muted-foreground">
                      We evaluate vendor stability, support quality, and long-term viability through comprehensive research.
                    </p>
                  </div>
                  <div>
                    <h4 className="font-semibold mb-2">Regular Updates</h4>
                    <p className="text-sm text-muted-foreground">
                      Scores are updated quarterly to reflect product improvements, new features, and changing market conditions.
                    </p>
                  </div>
                </div>
              </CardContent>
            </Card>
          </div>
        </div>
      </section>
    </div>
  );
}
