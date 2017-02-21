angular.module('loomioApp').directive 'pollCheckInForm', ->
  templateUrl: 'generated/components/poll/check_in/form/poll_check_in_form.html'
  controller: ($scope, FormService, KeyEventService, TranslationService) ->
    actionName = if $scope.poll.isNew() then 'created' else 'updated'

    $scope.submit = FormService.submit $scope, $scope.poll,
      successCallback: (data) -> $scope.$emit 'pollSaved', data.polls[0].key
      prepareFn: ->
        $scope.poll.pollOptionNames = [$scope.poll.affirmativeText, $scope.poll.negativeText]
      flashSuccess: "poll_check_in_form.check_in_#{actionName}"
      draftFields: ['title', 'details', 'affirmativeText', 'negativeText']

    TranslationService.eagerTranslate $scope,
      titlePlaceholder:   'poll_check_in_form.title_placeholder'
      detailsPlaceholder: 'poll_check_in_form.details_placeholder'
      actionPlaceholder:  'poll_check_in_form.action_placeholder'
      affirmativePlaceholder:  'poll_check_in_form.affirmative_placeholder'
      negativePlaceholder:  'poll_check_in_form.negative_placeholder'

    KeyEventService.submitOnEnter($scope)