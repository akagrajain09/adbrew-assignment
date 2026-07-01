from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
import os
from pymongo import MongoClient

mongo_uri = "mongodb://" + os.environ["MONGO_HOST"] + ":" + os.environ["MONGO_PORT"]
db = MongoClient(mongo_uri)["test_db"]


class TodoListView(APIView):
    def get(self, request):
        try:
            todos = [
                {
                    "id": str(todo["_id"]),
                    "description": todo["description"]
                }
                for todo in db.todos.find()
            ]

            return Response(todos, status=status.HTTP_200_OK)

        except Exception as error:
            return Response(
                {"error": str(error)},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )

    def post(self, request):
        try:
            description = request.data.get("description", "").strip()

            if not description:
                return Response(
                    {"error": "Description is required"},
                    status=status.HTTP_400_BAD_REQUEST
                )

            result = db.todos.insert_one({
                "description": description
            })

            return Response(
                {
                    "id": str(result.inserted_id),
                    "description": description
                },
                status=status.HTTP_201_CREATED
            )

        except Exception as error:
            return Response(
                {"error": str(error)},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )