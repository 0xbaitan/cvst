import z from "zod";
import { DateSchema } from "../helpers/date";

export const CertificationSchema = z.object({
  title: z.string().nonempty().nonoptional(),
  issuer: z.string().nonempty().optional(),
  "issuance-date": DateSchema.nonoptional(),
  "expiration-date": z.union([DateSchema, z.literal("Present")]).optional(),
  "credential-id": z.string().nonempty().optional(),
  "credential-url": z.url().optional(),
  description: z.string().optional(),
});

export const CertificationsSchema = z.array(CertificationSchema);
