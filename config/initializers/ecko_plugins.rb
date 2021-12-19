# frozen_string_literal: true

Ecko::Plugins::Stripe.register(stripe_api_key: ENV['STRIPE_API_KEY'], currency: 'USD')
Ecko::Plugins::Sponsor.register(
  gateways: [
    {
      name: 'Stripe',
      checkout: Ecko::Plugins.stripe.checkout_reference
    }
  ]
)
