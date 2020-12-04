#!/bin/sh

numb='770'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --weightb --aq-strength 0.5 --ipratio 1.1 --pbratio 1.4 --psy-rd 1.2 --qblur 0.2 --qcomp 0.8 --vbv-init 0.6 --aq-mode 1 --b-adapt 0 --bframes 8 --crf 30 --keyint 270 --lookahead-threads 1 --min-keyint 25 --qp 20 --qpstep 4 --qpmin 4 --qpmax 60 --rc-lookahead 18 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset veryslow --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,0.5,1.1,1.4,1.2,0.2,0.8,0.6,1,0,8,30,270,1,25,20,4,4,60,18,3,2000,-1:-1,dia,crop,veryslow,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"