module QuestionAnswer
  module PostSerializerExtension
    def actions_summary
      summaries = super.reject { |s| s[:id] === PostActionType.types[:vote] }

      if object.qa_enabled
        user = scope.current_user
        summary = {
          id: PostActionType.types[:vote],
          count: object.qa_vote_count
        }

        if user
          voted = object.qa_voted.include?(user.id)

          if voted
            summary[:acted] = true
            summary[:can_undo] = QuestionAnswer::Vote.can_undo(object, user)
          else
            summary[:can_act] = true
          end
        end

        summary.delete(:count) if summary[:count] == 0

        if summary[:can_act] || summary[:count]
          summaries + [summary]
        else
          summaries
        end
      else
        summaries
      end
    end

    attributes :qa_vote_count,
               :qa_voted,
               :qa_enabled,
               :last_answerer,
               :last_answered_at,
               :answer_count,
               :last_answer_post_number,
               :last_answerer

    def qa_vote_count
      object.qa_vote_count
    end

    def qa_voted
      object.qa_voted
    end

    def qa_enabled
      object.qa_enabled
    end

    def last_answerer
      object.topic.last_answerer
    end

    def include_last_answerer?
      object.qa_enabled
    end

    def last_answered_at
      object.topic.last_answered_at
    end

    def include_last_answered_at?
      object.qa_enabled
    end

    def answer_count
      object.topic.answer_count
    end

    def include_answer_count?
      object.qa_enabled
    end

    def last_answer_post_number
      object.topic.last_answer_post_number
    end

    def include_last_answer_post_number?
      object.qa_enabled
    end

    def last_answerer
      object.topic.last_answerer
    end

    def include_last_answerer?
      object.qa_enabled
    end
  end
end