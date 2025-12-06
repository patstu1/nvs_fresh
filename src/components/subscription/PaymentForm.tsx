
import React from 'react';
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import * as z from "zod";
import { CreditCard, Loader2 } from 'lucide-react';
import { Form, FormControl, FormField, FormItem, FormLabel, FormMessage } from "@/components/ui/form";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";

// Form validation schema for payment details
const paymentFormSchema = z.object({
  cardNumber: z.string().min(16, "Enter a valid card number").max(19),
  expiryDate: z.string().min(5, "Enter a valid expiry date (MM/YY)"),
  cvv: z.string().min(3, "Enter a valid CVV/CVC"),
  name: z.string().min(2, "Enter the cardholder name"),
});

interface PaymentFormProps {
  onSubmit: (values: z.infer<typeof paymentFormSchema>) => void;
  onApplePay: () => void;
  onBack: () => void;
  isProcessing?: boolean;
}

const PaymentForm: React.FC<PaymentFormProps> = ({ 
  onSubmit, 
  onApplePay, 
  onBack,
  isProcessing = false
}) => {
  const form = useForm<z.infer<typeof paymentFormSchema>>({
    resolver: zodResolver(paymentFormSchema),
    defaultValues: {
      cardNumber: '',
      expiryDate: '',
      cvv: '',
      name: '',
    },
  });
  
  return (
    <>
      <Form {...form}>
        <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-4">
          <FormField
            control={form.control}
            name="name"
            render={({ field }) => (
              <FormItem>
                <FormLabel>Cardholder Name</FormLabel>
                <FormControl>
                  <Input placeholder="Name on card" {...field} disabled={isProcessing} />
                </FormControl>
                <FormMessage />
              </FormItem>
            )}
          />
          
          <FormField
            control={form.control}
            name="cardNumber"
            render={({ field }) => (
              <FormItem>
                <FormLabel>Card Number</FormLabel>
                <FormControl>
                  <Input 
                    placeholder="1234 5678 9012 3456" 
                    {...field}
                    onChange={(e) => {
                      // Format card number with spaces
                      const value = e.target.value.replace(/\s+/g, '');
                      let formatted = '';
                      for (let i = 0; i < value.length; i++) {
                        if (i > 0 && i % 4 === 0) {
                          formatted += ' ';
                        }
                        formatted += value[i];
                      }
                      field.onChange(formatted);
                    }}
                    maxLength={19}
                    disabled={isProcessing}
                  />
                </FormControl>
                <FormMessage />
              </FormItem>
            )}
          />
          
          <div className="grid grid-cols-2 gap-4">
            <FormField
              control={form.control}
              name="expiryDate"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Expiry Date</FormLabel>
                  <FormControl>
                    <Input 
                      placeholder="MM/YY" 
                      {...field} 
                      onChange={(e) => {
                        let value = e.target.value.replace(/[^\d]/g, '');
                        if (value.length > 2) {
                          value = value.slice(0, 2) + '/' + value.slice(2, 4);
                        }
                        field.onChange(value);
                      }}
                      maxLength={5}
                      disabled={isProcessing}
                    />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />
            
            <FormField
              control={form.control}
              name="cvv"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>CVV/CVC</FormLabel>
                  <FormControl>
                    <Input 
                      placeholder="123" 
                      {...field} 
                      type="password"
                      maxLength={4}
                      disabled={isProcessing}
                    />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />
          </div>
          
          <div className="pt-4">
            <Button 
              type="submit" 
              className="w-full bg-[#E6FFF4] text-black py-3 rounded-lg font-semibold hover:bg-white transition-colors flex items-center justify-center"
              disabled={isProcessing}
            >
              {isProcessing ? (
                <>
                  <Loader2 className="w-4 h-4 mr-2 animate-spin" />
                  Processing...
                </>
              ) : (
                <>
                  <CreditCard className="w-4 h-4 mr-2" />
                  Start Free Trial
                </>
              )}
            </Button>
          </div>
        </form>
      </Form>
      
      <div className="mt-4 relative">
        <div className="absolute inset-0 flex items-center">
          <div className="w-full border-t border-[#E6FFF4]/20"></div>
        </div>
        <div className="relative flex justify-center text-xs uppercase">
          <span className="bg-[#1A1A1A] px-2 text-[#E6FFF4]/60">or pay with</span>
        </div>
      </div>
      
      <div className="mt-4">
        <button
          onClick={onApplePay}
          className="w-full bg-black text-white border border-[#E6FFF4]/30 py-3 rounded-lg font-semibold flex items-center justify-center"
          disabled={isProcessing}
        >
          {isProcessing ? (
            <>
              <Loader2 className="h-5 w-5 mr-2 animate-spin" />
              Processing...
            </>
          ) : (
            <>
              <svg className="h-5 w-5 mr-2" viewBox="0 0 24 24" fill="currentColor">
                <path d="M17.71 7.7C16.87 7.7 16.17 8.1 15.54 8.44C15.25 8.61 14.97 8.77 14.73 8.77C14.47 8.77 14.17 8.6 13.84 8.42C13.31 8.12 12.69 7.77 11.93 7.77C10.33 7.77 8.91 8.94 8.14 10.7C7.23 12.82 7.63 16.71 9.32 19.61C10.03 20.81 10.9 22.16 12.08 22.16C12.89 22.16 13.19 21.69 14.12 21.69C15.04 21.69 15.32 22.15 16.14 22.15C17.33 22.15 18.16 20.88 18.87 19.67C19.39 18.79 19.64 17.9 19.65 17.85C19.62 17.84 17.52 16.96 17.51 14.38C17.5 12.21 19.14 11.24 19.22 11.19C18.28 9.75 16.78 9.66 16.28 9.62C15.1 9.52 14.07 10.26 13.46 10.26C12.86 10.26 11.98 9.67 11.05 9.67M16.88 6.2C17.48 5.47 17.85 4.48 17.74 3.5C16.89 3.55 15.86 4.11 15.24 4.85C14.68 5.52 14.24 6.53 14.37 7.5C15.31 7.58 16.28 6.94 16.88 6.2Z"/>
              </svg>
              Apple Pay
            </>
          )}
        </button>
      </div>
      
      <p className="text-xs text-center text-[#E6FFF4]/50 mt-6">
        Your payment method will be securely stored. No charges until your free trial ends.
      </p>
      
      {!isProcessing && (
        <div className="mt-4 text-center">
          <button 
            onClick={onBack}
            className="text-sm text-[#E6FFF4]/70 hover:text-[#E6FFF4]"
            disabled={isProcessing}
          >
            Go back
          </button>
        </div>
      )}
    </>
  );
};

export default PaymentForm;
