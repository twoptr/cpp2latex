#include "DB_Initialize.h"

#include "DBU_FirstNamesMale.h"
#include "DBU_FirstNamesFemale.h"
#include "DBU_FamilyNames.h"
#include "DB_Students.h"
#include "DB_Teachers.h"
#include "DBA_StudentTeachers.h"

namespace
{
   struct Context
   {
         static const size_t C1 = 1777;
         static const size_t C2 = 2777;
         static const size_t C3 = 3217;
         size_t maleIdx = 7;
         size_t femaleIdx = 11;
         size_t familyIdx = 13;
   };

   void getNextName( Context & ctx,         ///< [inout]
                     size_t & n1,
                     size_t & n2,
                     bool & is_male
                   )
   {
      static const size_t males = S_DBU_FirstNamesMale::getInstance().getSize();
      static const size_t females = S_DBU_FirstNamesFemale::getInstance().getSize();
      static const size_t numFamilyNames = S_DBU_FamilyNames::getInstance().getSize();

      is_male = ctx.familyIdx % 2 == 0;
      ctx.maleIdx = (ctx.maleIdx + Context::C1 + rand() % 100) % males;
      ctx.femaleIdx = (ctx.femaleIdx + Context::C2 + rand() % 99) % females;
      ctx.familyIdx = (ctx.familyIdx + Context::C3 + rand() % 98) % numFamilyNames;

      n1 = is_male ? ctx.maleIdx : ctx.femaleIdx;
      n2 = ctx.familyIdx;
   }
}

void DB::initStudents( const size_t numOfStudents )
{
   size_t s = 0;
   Context ctx;

   while( s < numOfStudents )
   {
      size_t i1,i2;
      bool is_male;
      getNextName(ctx, i1, i2, is_male);

      S_DB_Students::getInstance().add(
        { is_male,
          i1,
          i2,
          42
        });

      ++s;
   }
}

void DB::initTeachers( const size_t numOfTeachers )
{
   size_t s = 0;
   Context ctx;

   while( s < numOfTeachers )
   {
      size_t i1,i2;
      bool is_male;
      getNextName(ctx, i1, i2, is_male);

      S_DB_Teachers::getInstance().add(
        { is_male,
          i1,
          i2,
          1988
        });

      ++s;
   }
}

void DB::initStudentTeacherAssocs()
{
   size_t teachers = S_DB_Teachers::getInstance().m_teacher.size();

   for( const auto & i : S_DB_Students::getInstance().m_student )
   {
      DB_Teacher::KeyId teacherId;
      teacherId.value = rand() % static_cast<int>(teachers);

      S_DBA_StudentTeachers::getInstance().add( i.getKeyId(), teacherId );
   }
}
