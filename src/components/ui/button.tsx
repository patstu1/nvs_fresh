
import * as React from "react"
import { Slot } from "@radix-ui/react-slot"
import { cva, type VariantProps } from "class-variance-authority"

import { cn } from "@/lib/utils"

const buttonVariants = cva(
  "inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0",
  {
    variants: {
      variant: {
        default: "bg-primary text-primary-foreground hover:bg-primary/90",
        destructive:
          "bg-destructive text-destructive-foreground hover:bg-destructive/90",
        outline:
          "border border-input bg-background hover:bg-accent hover:text-accent-foreground",
        secondary:
          "bg-secondary text-secondary-foreground hover:bg-secondary/80",
        ghost: "hover:bg-accent hover:text-accent-foreground",
        link: "text-primary underline-offset-4 hover:underline",
        ring: "bg-luxury-snakeskin-dark text-luxury-crystal border-2 border-luxury-pink/30 shadow-luxury-glow hover:border-luxury-pink/70 hover:shadow-crystal-shine",
        "ring-active": "bg-luxury-snakeskin-dark text-luxury-crystal border-2 border-luxury-pink/50 shadow-crystal-shine",
        crystal: "bg-luxury-crystal/10 text-luxury-crystal backdrop-blur-md border border-luxury-crystal/30 hover:bg-luxury-crystal/20 hover:border-luxury-crystal/50",
        luxury: "bg-luxury-snakeskin-medium/80 text-luxury-crystal backdrop-blur-sm border border-luxury-pink/20 hover:border-luxury-pink/40 shadow-luxury-glow",
        gold: "bg-gradient-to-r from-luxury-accent-gold/80 to-luxury-accent-gold/50 text-luxury-snakeskin-light border border-luxury-accent-gold/40 shadow-luxury-glow",
        olive: "bg-luxury-olive-medium/80 text-luxury-crystal border border-luxury-olive-light/30 hover:bg-luxury-olive-medium hover:border-luxury-olive-light/50",
        fur: "bg-luxury-fur-medium/80 text-white border border-luxury-fur-light/30 hover:bg-luxury-fur-medium hover:border-luxury-fur-light/50",
        snakeskin: "bg-luxury-snakeskin-dark/90 text-luxury-crystal border border-luxury-snakeskin-light/30 hover:border-luxury-snakeskin-light/60",
        chandelier: "bg-transparent text-luxury-crystal crystal-chandelier hover:shadow-chandelier-glow",
      },
      size: {
        default: "h-10 px-4 py-2",
        sm: "h-9 rounded-md px-3",
        lg: "h-11 rounded-md px-8",
        xl: "h-12 rounded-md px-10 text-base",
        icon: "h-10 w-10",
        "ring-icon": "h-10 w-10 rounded-full",
      },
    },
    defaultVariants: {
      variant: "default",
      size: "default",
    },
  }
)

export interface ButtonProps
  extends React.ButtonHTMLAttributes<HTMLButtonElement>,
    VariantProps<typeof buttonVariants> {
  asChild?: boolean
}

const Button = React.forwardRef<HTMLButtonElement, ButtonProps>(
  ({ className, variant, size, asChild = false, ...props }, ref) => {
    const Comp = asChild ? Slot : "button"
    return (
      <Comp
        className={cn(buttonVariants({ variant, size, className }))}
        ref={ref}
        {...props}
      />
    )
  }
)
Button.displayName = "Button"

export { Button, buttonVariants }
