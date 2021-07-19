from article.models import Article
from django.contrib import admin

# Register your models here.


class ArticleAdmin(admin.ModelAdmin):
    pass


admin.site.register(Article, ArticleAdmin)