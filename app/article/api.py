from .models import Article
from rest_framework.pagination import PageNumberPagination
from rest_framework.generics import ListAPIView
from .serializers import ArticleSummarySerializer, ArticleSerializer
from rest_framework.viewsets import ModelViewSet
from rest_framework import permissions
from rest_framework.exceptions import MethodNotAllowed


class ArticlePagination(PageNumberPagination):
    page_size = 100
    page_size_query_param = 'page_size'
    max_page_size = 1000


class ArticleApi(ModelViewSet):
    queryset = Article.objects.all()
    permission_classes = [permissions.IsAuthenticated]

    def get_serializer_class(self):
        if self.action == 'list':
            return ArticleSummarySerializer
        else:
            return ArticleSerializer