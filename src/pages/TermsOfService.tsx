
import React from 'react';
import { ArrowLeft } from 'lucide-react';
import { useNavigate } from 'react-router-dom';

const TermsOfService: React.FC = () => {
  const navigate = useNavigate();
  
  return (
    <div className="min-h-screen bg-black text-[#E6FFF4] pb-20">
      {/* Header */}
      <div className="fixed top-0 left-0 right-0 bg-[#1A1A1A] z-10">
        <div className="flex items-center px-4 py-3">
          <button onClick={() => navigate(-1)} className="mr-3">
            <ArrowLeft className="w-6 h-6" />
          </button>
          <h1 className="text-xl font-semibold">Terms of Service</h1>
        </div>
      </div>
      
      <div className="pt-16 px-4 max-w-3xl mx-auto">
        <div className="space-y-6">
          <section>
            <h2 className="text-xl font-semibold mb-3">Terms of Service for YO BRO</h2>
            <p className="mb-2">Last Updated: April 8, 2025</p>
            <p>
              These Terms of Service ("Terms") govern your access to and use of the YO BRO application. 
              Please read these Terms carefully before using our services.
            </p>
          </section>
          
          <section>
            <h3 className="text-lg font-medium mb-2">Using YO BRO</h3>
            <p className="mb-2">
              By using YO BRO, you agree to these Terms and our Privacy Policy. If you do not agree, you may not use our services.
            </p>
            <p>
              You must be at least 18 years old to use YO BRO. By using our services, you represent and warrant that you meet this age requirement.
            </p>
          </section>
          
          <section>
            <h3 className="text-lg font-medium mb-2">User Accounts</h3>
            <p className="mb-2">
              You are responsible for maintaining the security of your account and password. 
              YO BRO cannot and will not be liable for any loss or damage resulting from your failure to comply with this security obligation.
            </p>
          </section>
          
          <section>
            <h3 className="text-lg font-medium mb-2">Subscriptions and Payments</h3>
            <p className="mb-2">
              YO BRO offers free and paid subscription options. By subscribing to YO BRO PRO, you agree to the following:
            </p>
            <ul className="list-disc pl-6 space-y-1 text-[#E6FFF4]/80">
              <li>You authorize us to charge your payment method on a recurring basis</li>
              <li>Subscriptions automatically renew until cancelled</li>
              <li>You can cancel your subscription at any time through the app</li>
              <li>No refunds will be provided for partial subscription periods</li>
              <li>Prices are subject to change with notice</li>
              <li>Free trial periods convert to paid subscriptions unless cancelled before the end of the trial</li>
            </ul>
          </section>
          
          <section>
            <h3 className="text-lg font-medium mb-2">Acceptable Use</h3>
            <p className="mb-2">
              You agree not to engage in any of the following prohibited activities:
            </p>
            <ul className="list-disc pl-6 space-y-1 text-[#E6FFF4]/80">
              <li>Violating any laws or regulations</li>
              <li>Posting content that is harmful, threatening, abusive, or discriminatory</li>
              <li>Impersonating other users or entities</li>
              <li>Attempting to access other users' accounts without authorization</li>
              <li>Using the service for any commercial purpose without our consent</li>
              <li>Interfering with or disrupting the service or servers</li>
              <li>Circumventing any technological measures we employ</li>
            </ul>
          </section>
          
          <section>
            <h3 className="text-lg font-medium mb-2">Termination</h3>
            <p>
              We may terminate or suspend your account at our sole discretion, without notice, for conduct that we believe violates these Terms or is harmful to other users, us, or third parties, or for any other reason.
            </p>
          </section>
          
          <section>
            <h3 className="text-lg font-medium mb-2">Changes to Terms</h3>
            <p>
              We may modify these Terms at any time. We will notify you of material changes by posting the new Terms on the app and updating the "Last Updated" date.
            </p>
          </section>
          
          <section>
            <h3 className="text-lg font-medium mb-2">Contact Us</h3>
            <p>
              If you have any questions about these Terms, please contact us at legal@yobro.app
            </p>
          </section>
        </div>
      </div>
    </div>
  );
};

export default TermsOfService;
