#!/bin/sh

numb='535'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-weightb --aq-strength 0.5 --ipratio 1.5 --pbratio 1.0 --psy-rd 3.8 --qblur 0.4 --qcomp 0.7 --vbv-init 0.8 --aq-mode 2 --b-adapt 1 --bframes 2 --crf 50 --keyint 290 --lookahead-threads 0 --min-keyint 27 --qp 40 --qpstep 5 --qpmin 1 --qpmax 60 --rc-lookahead 48 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset faster --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,0.5,1.5,1.0,3.8,0.4,0.7,0.8,2,1,2,50,290,0,27,40,5,1,60,48,1,2000,-2:-2,hex,show,faster,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"