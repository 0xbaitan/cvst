import z from "zod";

export const ContactSchema = z.object({
  name: z.string().nonempty().nonoptional(),
  phone: z.e164().optional(),
  location: z.string().optional(),
  email: z.email().optional(),
  website: z.url().optional(),
  "linkedin-user-id": z.string().optional(),
  "github-username": z.string().optional(),
});
