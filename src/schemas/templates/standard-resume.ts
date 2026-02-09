import { z } from "zod";
import {
  CertificationsSchema,
  ContactSchema,
  EducationSchema,
  ExperienceSchema,
  ProjectsSchema,
  SkillsSchema,
  SummarySchema,
} from "../sections";
import {
  ColorSchema,
  FontSchema,
  MarginsSchema,
  PaperSchema,
} from "../helpers";
import { PageSettingsSchema } from "../settings/page";
import { SectionSettingsSchema } from "../settings/section";

const SectionsSchema = z.object({
  contact: ContactSchema.nonoptional(),
  summary: SummarySchema.optional(),
  experience: ExperienceSchema.min(1).optional(),
  projects: ProjectsSchema.min(1).optional(),
  education: EducationSchema.min(1).optional(),
  skills: SkillsSchema.min(1).optional(),
  certifications: CertificationsSchema.min(1).optional(),
});

const SettingsSchema = z.object({
  page: PageSettingsSchema.optional(),
  sections: SectionSettingsSchema.optional(),
});

const ResumeSchema = z.object({
  // === Core Resume Config ===
  settings: SettingsSchema.partial().optional(),
  // === Personal Info ===

  sections: SectionsSchema.nonoptional(),
});

export default ResumeSchema;
