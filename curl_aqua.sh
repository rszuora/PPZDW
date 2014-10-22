#!/bin/bash
# 
#  curl aqua
#  Using aqua pull all the data sources - you need to manually add any custom
#  fields to the appropriate query in this file. Zuora is quite unforgiving if 
#  you screw this up and miss or add a comma or two. This shipped version works,
#  if it later fails, best of luck.
#
#  Have to feed in the aqua URL, login and password.
#
#  richard.sawey@zuora.com
#
#  Written in bash, but only tested on a Mac running Mavericks, 10.9.5, your
#  mileage may vary
#

USER_NAME=$2
PASSWORD=$3
BASE_URL=$1

echo 
echo "============= Posting the Aqua Job ===========" 
echo 
curl -i -k -u $USER_NAME:$PASSWORD -H "Content-Type:application/json" -H "Accept:application/json" -d '
{
"format" : "csv", 
"version" : "1.1", 
"name" : "PMZDW", 
"encrypted" : "none", 
"partner" : "", 
"project" : "", 
"queries" : [ { 
  "name" : "Payment", 
  "query" : "select Payment.AccountingCode, Payment.Amount, Payment.AppliedCreditBalanceAmount, Payment.AuthTransactionId, Payment.BankIdentificationNumber, Payment.CancelledOn, Payment.Comment, Payment.CreatedById, Payment.CreatedDate, Payment.EffectiveDate, Payment.Gateway, Payment.GatewayOrderId, Payment.GatewayResponse, Payment.GatewayResponseCode, Payment.GatewayState, Payment.Id, Payment.MarkedForSubmissionOn, Payment.PaymentNumber, Payment.ReferenceId, Payment.RefundAmount, Payment.SecondPaymentReferenceId, Payment.SettledOn, Payment.SoftDescriptor, Payment.SoftDescriptorPhone, Payment.Status, Payment.SubmittedOn, Payment.TransferredToAccounting, Payment.Type, Payment.UpdatedById, Payment.UpdatedDate from Payment", 
  "type" : "zoqlexport" 
  },
  { 
  "name" : "InvoiceItemAdjustment", 
  "query" : "select InvoiceItemAdjustment.AccountId, InvoiceItemAdjustment.AccountingCode, InvoiceItemAdjustment.AdjustmentDate, InvoiceItemAdjustment.AdjustmentNumber, InvoiceItemAdjustment.Amount, InvoiceItemAdjustment.CancelledById, InvoiceItemAdjustment.CancelledDate, InvoiceItemAdjustment.Comment, InvoiceItemAdjustment.CreatedById, InvoiceItemAdjustment.CreatedDate, InvoiceItemAdjustment.Id, InvoiceItemAdjustment.InvoiceId, InvoiceItemAdjustment.InvoiceItemName, InvoiceItemAdjustment.InvoiceNumber, InvoiceItemAdjustment.ReasonCode, InvoiceItemAdjustment.ReferenceId, InvoiceItemAdjustment.ServiceEndDate, InvoiceItemAdjustment.ServiceStartDate, InvoiceItemAdjustment.SourceId, InvoiceItemAdjustment.SourceType, InvoiceItemAdjustment.Status, InvoiceItemAdjustment.TransferredToAccounting, InvoiceItemAdjustment.Type, InvoiceItemAdjustment.UpdatedById, InvoiceItemAdjustment.UpdatedDate from InvoiceItemAdjustment", 
  "type" : "zoqlexport" 
  },
 { 
  "name" : "TaxationItem", 
  "query" : "select TaxationItem.AccountingCode, TaxationItem.CreatedById, TaxationItem.CreatedDate, TaxationItem.ExemptAmount, TaxationItem.Id, TaxationItem.Jurisdiction, TaxationItem.LocationCode, TaxationItem.Name, TaxationItem.TaxAmount, TaxationItem.TaxCode, TaxationItem.TaxCodeDescription, TaxationItem.TaxDate, TaxationItem.TaxMode, TaxationItem.TaxRate, TaxationItem.TaxRateDescription, TaxationItem.TaxRateType, TaxationItem.UpdatedById, TaxationItem.UpdatedDate from TaxationItem", 
  "type" : "zoqlexport" 
 },
 { 
  "name" : "InvoiceAdjustment", 
  "query" : "select InvoiceAdjustment.AccountingCode, InvoiceAdjustment.AdjustmentDate, InvoiceAdjustment.AdjustmentNumber, InvoiceAdjustment.Amount, InvoiceAdjustment.CancelledById, InvoiceAdjustment.CancelledOn, InvoiceAdjustment.Comments, InvoiceAdjustment.CreatedById, InvoiceAdjustment.CreatedDate, InvoiceAdjustment.Id, InvoiceAdjustment.ImpactAmount, InvoiceAdjustment.InvoiceNumber, InvoiceAdjustment.ReasonCode, InvoiceAdjustment.ReferenceId, InvoiceAdjustment.Status, InvoiceAdjustment.TransferredToAccounting, InvoiceAdjustment.Type, InvoiceAdjustment.UpdatedById, InvoiceAdjustment.UpdatedDate from InvoiceAdjustment", 
  "type" : "zoqlexport" 
 },
 { 
  "name" : "BillingRun", 
  "query" : "select BillingRun.BillingRunNumber, BillingRun.CreatedById, BillingRun.CreatedDate, BillingRun.EndDate, BillingRun.ErrorMessage, BillingRun.ExecutedDate, BillingRun.Id, BillingRun.InvoiceDate, BillingRun.NumberOfAccounts, BillingRun.NumberOfInvoices, BillingRun.StartDate, BillingRun.Status, BillingRun.TargetDate, BillingRun.TargetType, BillingRun.TotalTime, BillingRun.UpdatedById, BillingRun.UpdatedDate from BillingRun", 
  "type" : "zoqlexport" 
 },
 { 
  "name" : "CreditBalanceAdjustment", 
  "query" : "select CreditBalanceAdjustment.AccountingCode, CreditBalanceAdjustment.AdjustmentDate, CreditBalanceAdjustment.Amount, CreditBalanceAdjustment.CancelledOn, CreditBalanceAdjustment.Comment, CreditBalanceAdjustment.CreatedById, CreditBalanceAdjustment.CreatedDate, CreditBalanceAdjustment.Id, CreditBalanceAdjustment.Number, CreditBalanceAdjustment.ReasonCode, CreditBalanceAdjustment.ReferenceId, CreditBalanceAdjustment.SourceTransactionId, CreditBalanceAdjustment.SourceTransactionNumber, CreditBalanceAdjustment.SourceTransactionType, CreditBalanceAdjustment.Status, CreditBalanceAdjustment.TransferredToAccounting, CreditBalanceAdjustment.Type, CreditBalanceAdjustment.UpdatedById, CreditBalanceAdjustment.UpdatedDate from CreditBalanceAdjustment", 
  "type" : "zoqlexport" 
 },
 { 
  "name" : "Usage", 
  "query" : "select Usage.AccountNumber, Usage.CreatedById, Usage.CreatedDate, Usage.EndDateTime, Usage.Id, Usage.Quantity, Usage.RbeStatus, Usage.SourceType, Usage.StartDateTime, Usage.SubmissionDateTime, Usage.UOM, Usage.UpdatedById, Usage.UpdatedDate from Usage", 
  "type" : "zoqlexport" 
 },
 { 
  "name" : "InvoiceItem", 
  "query" : "select InvoiceItem.AccountingCode, InvoiceItem.AppliedToInvoiceItemId, InvoiceItem.ChargeAmount, InvoiceItem.ChargeDate, InvoiceItem.ChargeName, InvoiceItem.CreatedById, InvoiceItem.CreatedDate, InvoiceItem.Id, InvoiceItem.ProcessingType, InvoiceItem.Quantity, InvoiceItem.RevRecStartDate, InvoiceItem.SKU, InvoiceItem.ServiceEndDate, InvoiceItem.ServiceStartDate, InvoiceItem.SubscriptionId, InvoiceItem.TaxAmount, InvoiceItem.TaxCode, InvoiceItem.TaxExemptAmount, InvoiceItem.TaxMode, InvoiceItem.UOM, InvoiceItem.UnitPrice, InvoiceItem.UpdatedById, InvoiceItem.UpdatedDate from InvoiceItem", 
  "type" : "zoqlexport" 
 },
 { 
  "name" : "Invoice", 
  "query" : "select Invoice.AdjustmentAmount, Invoice.Amount, Invoice.AmountWithoutTax, Invoice.Balance, Invoice.Comments, Invoice.CreatedById, Invoice.CreatedDate, Invoice.CreditBalanceAdjustmentAmount, Invoice.DueDate, Invoice.Id, Invoice.IncludesOneTime, Invoice.IncludesRecurring, Invoice.IncludesUsage, Invoice.InvoiceDate, Invoice.InvoiceNumber, Invoice.LastEmailSentDate, Invoice.PaymentAmount, Invoice.PostedBy, Invoice.PostedDate, Invoice.RefundAmount, Invoice.Source, Invoice.SourceId, Invoice.Status, Invoice.TargetDate, Invoice.TaxAmount, Invoice.TaxExemptAmount, Invoice.TransferredToAccounting, Invoice.UpdatedById, Invoice.UpdatedDate from Invoice", 
  "type" : "zoqlexport" 
 },
 { 
  "name" : "InvoicePayment", 
  "query" : "select InvoicePayment.Amount, InvoicePayment.CreatedById, InvoicePayment.CreatedDate, InvoicePayment.Id, InvoicePayment.RefundAmount, InvoicePayment.UpdatedById, InvoicePayment.UpdatedDate from InvoicePayment", 
  "type" : "zoqlexport" 
 },
 { 
  "name" : "Refund", 
  "query" : "select Refund.AccountingCode, Refund.Amount, Refund.CancelledOn, Refund.Comment, Refund.CreatedById, Refund.CreatedDate, Refund.Gateway, Refund.GatewayResponse, Refund.GatewayResponseCode, Refund.GatewayState, Refund.Id, Refund.MarkedForSubmissionOn, Refund.MethodType, Refund.PaymentMethodId, Refund.ReasonCode, Refund.ReferenceID, Refund.RefundDate, Refund.RefundNumber, Refund.RefundTransactionTime, Refund.SecondRefundReferenceId, Refund.SettledOn, Refund.SoftDescriptor, Refund.SoftDescriptorPhone, Refund.SourceType, Refund.Status, Refund.SubmittedOn, Refund.TransferredToAccounting, Refund.Type, Refund.UpdatedById, Refund.UpdatedDate from Refund", 
  "type" : "zoqlexport" 
 },
 { 
  "name" : "RatePlan", 
  "query" : "select RatePlan.AmendmentType, RatePlan.CreatedById, RatePlan.CreatedDate, RatePlan.Id, RatePlan.Name, RatePlan.UpdatedById, RatePlan.UpdatedDate from RatePlan", 
  "type" : "zoqlexport" 
 },
 { 
  "name" : "RatePlanCharge", 
  "query" : "select RatePlanCharge.AccountingCode, RatePlanCharge.ApplyDiscountTo, RatePlanCharge.BillCycleDay, RatePlanCharge.BillCycleType, RatePlanCharge.BillingPeriod, RatePlanCharge.BillingPeriodAlignment, RatePlanCharge.ChargeModel, RatePlanCharge.ChargeNumber, RatePlanCharge.ChargeType, RatePlanCharge.ChargedThroughDate, RatePlanCharge.CreatedById, RatePlanCharge.CreatedDate, RatePlanCharge.DMRC, RatePlanCharge.DTCV, RatePlanCharge.Description, RatePlanCharge.DiscountLevel, RatePlanCharge.EffectiveEndDate, RatePlanCharge.EffectiveStartDate, RatePlanCharge.Id, RatePlanCharge.IsLastSegment, RatePlanCharge.MRR, RatePlanCharge.Name, RatePlanCharge.NumberOfPeriods, RatePlanCharge.OriginalId, RatePlanCharge.OverageCalculationOption, RatePlanCharge.OverageUnusedUnitsCreditOption, RatePlanCharge.ProcessedThroughDate, RatePlanCharge.Quantity, RatePlanCharge.RevRecCode, RatePlanCharge.RevenueRecognitionRuleName, RatePlanCharge.RevRecTriggerCondition, RatePlanCharge.Segment, RatePlanCharge.SpecificBillingPeriod, RatePlanCharge.TCV, RatePlanCharge.TriggerDate, RatePlanCharge.TriggerEvent, RatePlanCharge.UOM, RatePlanCharge.UpToPeriods, RatePlanCharge.UpdatedById, RatePlanCharge.UpdatedDate, RatePlanCharge.Version from RatePlanCharge", 
  "type" : "zoqlexport" 
 },
 { 
  "name" : "RatePlanChargeTier", 
  "query" : "select RatePlanChargeTier.CreatedById, RatePlanChargeTier.CreatedDate, RatePlanChargeTier.Currency, RatePlanChargeTier.DiscountAmount, RatePlanChargeTier.DiscountPercentage, RatePlanChargeTier.EndingUnit, RatePlanChargeTier.Id, RatePlanChargeTier.IncludedUnits, RatePlanChargeTier.OveragePrice, RatePlanChargeTier.Price, RatePlanChargeTier.PriceFormat, RatePlanChargeTier.StartingUnit, RatePlanChargeTier.Tier, RatePlanChargeTier.UpdatedById, RatePlanChargeTier.UpdatedDate from RatePlanChargeTier", 
  "type" : "zoqlexport" 
 },
 { 
  "name" : "RefundInvoicePayment", 
  "query" : "select RefundInvoicePayment.CreatedById, RefundInvoicePayment.CreatedDate, RefundInvoicePayment.Id, RefundInvoicePayment.RefundAmount, RefundInvoicePayment.UpdatedById, RefundInvoicePayment.UpdatedDate from RefundInvoicePayment", 
  "type" : "zoqlexport" 
 },
 { 
  "name" : "Subscription", 
  "query" : "select Subscription.AutoRenew, Subscription.CancelledDate, Subscription.ContractAcceptanceDate, Subscription.ContractEffectiveDate, Subscription.CreatedById, Subscription.CreatedDate, Subscription.CreatorAccountId, Subscription.CreatorInvoiceOwnerId, Subscription.Id, Subscription.InitialTerm, Subscription.InvoiceOwnerId, Subscription.IsInvoiceSeparate, Subscription.Name, Subscription.Notes, Subscription.OriginalCreatedDate, Subscription.OriginalId, Subscription.PreviousSubscriptionId, Subscription.RenewalTerm, Subscription.ServiceActivationDate, Subscription.Status, Subscription.SubscriptionEndDate, Subscription.SubscriptionStartDate, Subscription.TermEndDate, Subscription.TermStartDate, Subscription.TermType, Subscription.UpdatedById, Subscription.UpdatedDate, Subscription.Version from Subscription", 
  "type" : "zoqlexport" 
 },
 { 
  "name" : "Subscription", 
  "query" : "select SubscriptionVersionAmendment.AutoRenew, SubscriptionVersionAmendment.Code, SubscriptionVersionAmendment.ContractEffectiveDate, SubscriptionVersionAmendment.CreatedById, SubscriptionVersionAmendment.CreatedDate, SubscriptionVersionAmendment.CustomerAcceptanceDate, SubscriptionVersionAmendment.Description, SubscriptionVersionAmendment.EffectiveDate, SubscriptionVersionAmendment.Id, SubscriptionVersionAmendment.InitialTerm, SubscriptionVersionAmendment.Name, SubscriptionVersionAmendment.RenewalTerm, SubscriptionVersionAmendment.ServiceActivationDate, SubscriptionVersionAmendment.Status, SubscriptionVersionAmendment.SubscriptionId, SubscriptionVersionAmendment.TermStartDate, SubscriptionVersionAmendment.TermType, SubscriptionVersionAmendment.Type, SubscriptionVersionAmendment.UpdatedById, SubscriptionVersionAmendment.UpdatedDate from Subscription", 
  "type" : "zoqlexport" 
 },
 { 
  "name" : "Account", 
  "query" : "select Account.Balance, Account.AccountNumber, Account.AdditionalEmailAddresses, Account.AllowInvoiceEdit, Account.AutoPay, Account.BillCycleDay, Account.BcdSettingOption, Account.Batch, Account.Mrr, Account.CrmId, Account.CustomerServiceRepName, Account.CommunicationProfileId, Account.CreatedById, Account.CreatedDate, Account.CreditBalance, Account.Currency, Account.Id, Account.InvoiceDeliveryPrefsEmail, Account.InvoiceDeliveryPrefsPrint, Account.InvoiceTemplateId, Account.LastInvoiceDate, Account.Name, Account.Notes, Account.PurchaseOrderNumber, Account.ParentId, Account.PaymentGateway, Account.PaymentTerm, Account.SalesRepName, Account.Status, Account.TaxExemptCertificateID, Account.TaxExemptCertificateType, Account.TaxExemptDescription, Account.TaxExemptEffectiveDate, Account.TaxExemptExpirationDate, Account.TaxExemptIssuingJurisdiction, Account.TaxExemptStatus, Account.TotalInvoiceBalance, Account.UpdatedById, Account.UpdatedDate from Account", 
  "type" : "zoqlexport" 
 },
 { 
  "name" : "Product", 
  "query" : "select Product.AllowFeatureChanges, Product.CreatedById, Product.CreatedDate, Product.Description, Product.EffectiveEndDate, Product.EffectiveStartDate, Product.Id, Product.Name, Product.SKU, Product.UpdatedById, Product.UpdatedDate from Product", 
  "type" : "zoqlexport" 
 },
 { 
  "name" : "ProductRatePlanCharge", 
  "query" : "select ProductRatePlan.CreatedById, ProductRatePlan.CreatedDate, ProductRatePlan.Description, ProductRatePlan.EffectiveEndDate, ProductRatePlan.EffectiveStartDate, ProductRatePlan.Id, ProductRatePlan.Name, ProductRatePlan.UpdatedById, ProductRatePlan.UpdatedDate from ProductRatePlanCharge", 
  "type" : "zoqlexport" 
 },
 { 
  "name" : "ProductRatePlanCharge", 
  "query" : "select ProductRatePlanCharge.AccountingCode, ProductRatePlanCharge.ApplyDiscountTo, ProductRatePlanCharge.BillCycleDay, ProductRatePlanCharge.BillCycleType, ProductRatePlanCharge.BillingPeriod, ProductRatePlanCharge.BillingPeriodAlignment, ProductRatePlanCharge.ChargeModel, ProductRatePlanCharge.ChargeType, ProductRatePlanCharge.CreatedById, ProductRatePlanCharge.CreatedDate, ProductRatePlanCharge.DefaultQuantity, ProductRatePlanCharge.DeferredRevenueAccount, ProductRatePlanCharge.Description, ProductRatePlanCharge.DiscountLevel, ProductRatePlanCharge.Id, ProductRatePlanCharge.IncludedUnits, ProductRatePlanCharge.LegacyRevenueReporting, ProductRatePlanCharge.MaxQuantity, ProductRatePlanCharge.MinQuantity, ProductRatePlanCharge.Name, ProductRatePlanCharge.NumberOfPeriod, ProductRatePlanCharge.OverageCalculationOption, ProductRatePlanCharge.OverageUnusedUnitsCreditOption, ProductRatePlanCharge.PriceChangeOption, ProductRatePlanCharge.PriceIncreasePercentage, ProductRatePlanCharge.RecognizedRevenueAccount, ProductRatePlanCharge.RevRecCode, ProductRatePlanCharge.RevenueRecognitionRuleName, ProductRatePlanCharge.RevRecTriggerCondition, ProductRatePlanCharge.SmoothingModel, ProductRatePlanCharge.SpecificBillingPeriod, ProductRatePlanCharge.TaxCode, ProductRatePlanCharge.TaxMode, ProductRatePlanCharge.Taxable, ProductRatePlanCharge.TriggerEvent, ProductRatePlanCharge.UOM, ProductRatePlanCharge.UpToPeriods, ProductRatePlanCharge.UpdatedById, ProductRatePlanCharge.UpdatedDate, ProductRatePlanCharge.UseDiscountSpecificAccountingCode, ProductRatePlanCharge.UseTenantDefaultForPriceChange from ProductRatePlanCharge", 
  "type" : "zoqlexport" 
 },
 { 
  "name" : "ProductRatePlanChargeTier", 
  "query" : "select ProductRatePlanChargeTier.Active, ProductRatePlanChargeTier.CreatedById, ProductRatePlanChargeTier.CreatedDate, ProductRatePlanChargeTier.Currency, ProductRatePlanChargeTier.DiscountAmount, ProductRatePlanChargeTier.DiscountPercentage, ProductRatePlanChargeTier.EndingUnit, ProductRatePlanChargeTier.Id, ProductRatePlanChargeTier.IncludedUnits, ProductRatePlanChargeTier.OveragePrice, ProductRatePlanChargeTier.Price, ProductRatePlanChargeTier.PriceFormat, ProductRatePlanChargeTier.StartingUnit, ProductRatePlanChargeTier.Tier, ProductRatePlanChargeTier.UpdatedById, ProductRatePlanChargeTier.UpdatedDate from ProductRatePlanChargeTier", 
  "type" : "zoqlexport" 
  } ,
   { 
  "name" : "Contact", 
  "query" : "select Contact.AccountId, Contact.Address1, Contact.Address2, Contact.City, Contact.Country, Contact.County, Contact.CreatedById, Contact.CreatedDate, Contact.Description, Contact.Fax, Contact.FirstName, Contact.HomePhone, Contact.Id, Contact.LastName, Contact.MobilePhone, Contact.NickName, Contact.OtherPhone, Contact.OtherPhoneType, Contact.PersonalEmail, Contact.PostalCode, Contact.State, Contact.TaxRegion, Contact.UpdatedById, Contact.UpdatedDate, Contact.WorkEmail, Contact.WorkPhone from Contact", 
  "type" : "zoqlexport" 
  } 
 ] 
} 
 ' -X POST $BASE_URL/api/batch-query/
 
