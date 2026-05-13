# Functions Examples

[Back to rules](../SKILL.md#functions)

## Bad: Long mixed-responsibility function

```go
func handleOrder(ctx context.Context, in OrderInput, db DB, cli Mailer) error {
    if in.CustomerID == "" {
        return ErrInvalidCustomer
    }
    subtotal := 0
    for _, item := range in.Items {
        if item.Qty <= 0 {
            return ErrInvalidQty
        }
        subtotal += item.Qty * item.UnitPrice
    }
    discount := 0
    if in.IsLoyalCustomer {
        discount = subtotal / 10
    }
    tax := (subtotal - discount) * 7 / 100
    total := subtotal - discount + tax
    if err := db.SaveOrder(ctx, in, total); err != nil {
        return err
    }
    if err := cli.SendReceipt(ctx, in.CustomerID, total); err != nil {
        return err
    }
    return nil
}
```

## Good: Parent orchestrates, children execute

```go
func handleOrder(ctx context.Context, in OrderInput, deps Deps) error {
    if err := validateOrder(in); err != nil {
        return err
    }

    totals := computeTotals(in)

    if err := persistOrder(ctx, in, totals, deps.DB); err != nil {
        return err
    }

    return sendReceipt(ctx, in.CustomerID, totals.Total, deps.Mailer)
}
```
