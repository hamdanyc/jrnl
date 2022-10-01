# eb_form.R

class <- c("Outstanding Work","Excellent Work","Good Quality",
                    "Acceptable","Adequate Work","Limited Work","Fail\n(Unacceptable Work)")
mark <- c("", "40 mark","36  marks", "12 marks", "6 marks", "6 marks")
cont <- c("Excellent description and discussion of main issues and material with evidence of critical evaluation (32-40)",
             "Detailed description of main issues and material with evidence of evaluation (28-31)",
             "Description of main issues and material with occasional evidence of discussion (24-27)",
             "Description of main issues and material only (20-23)",
             "Limited description of main  issues and material only (16-19)",
             "Omission of some relevant material (14-15)",
             "Insufficient and largely irrelevant material (0-13)")
know <- c("Excellent Knowledge and depth of understanding of principles and concepts (29-36)",
               "Knowledge and depth of understanding of principles and concepts (25-28)",
               "Knowledge and sound understanding of the key principles and concepts (21-24)",
               "Basic knowledge of the key principles and concepts only (18-20)",
               "Adequate knowledge of key  principles and concepts only (14-17)",
               "Limited and or inconsistent knowledge and understanding of key principles and concepts (12-13)",
               "Little or no evidence of knowledge and understanding of the key principles and concepts (0-11)")
read <- c("Evidence of reading a wide range of appropriate supplementary sources (10-12)",
             "Evidence of reading Appropriate supplementary sources (8-9)",
             "Evidence of directed reading and some supplementary sources (7)",
             "Evidence of directed reading (6)",
             "Limited evidence of reading (5)",
             "Evidence of minimal reading only (4)",
             "Little or no evidence of reading (0-3)")
ref <- c("Excellent referencing and bibliography (6)",
         "Accurate referencing and bibliography (5)",
         "Appropriate referencing and bibliography (4)",
         "Adequate referencing and bibliography (3)",
         "Limited referencing and Bibliography (2)",
         "Inadequate referencing and bibliography (1)",
         "Little or no referencing and bibliography (0)")
pres <- c("Excellent presentation, logically structured, using correct grammar and spelling (6)",
          "Good presentation logically structured, using correct grammar and spelling (5)",
          "Orderly presentation, competently structured and acceptable grammar and  spelling (4)",
          "Adequate presentation and structure, acceptable gram (3)",
          "Weak presentation and structure, acceptable grammar and spelling (2)",
          "Poor presentation, structure, grammar and Spelling (1)",
          "Unacceptable presentation, grammar and spelling (0)")


form <- data.frame(class, cont, know, read, ref, pres, stringsAsFactors = FALSE)
names(form) <- c("Classification", "Content", "Knowledge and Understanding",
               "Evidence of Reading", "Referencing and Bibliography",
               "Presentation Grammar and Spelling")
form <- rbind(mark,form)
