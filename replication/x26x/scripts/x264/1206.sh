#!/bin/sh

numb='1207'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-weightb --aq-strength 3.0 --ipratio 1.6 --pbratio 1.4 --psy-rd 4.4 --qblur 0.3 --qcomp 0.9 --vbv-init 0.2 --aq-mode 2 --b-adapt 1 --bframes 4 --crf 5 --keyint 270 --lookahead-threads 0 --min-keyint 25 --qp 0 --qpstep 4 --qpmin 1 --qpmax 67 --rc-lookahead 18 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset placebo --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,3.0,1.6,1.4,4.4,0.3,0.9,0.2,2,1,4,5,270,0,25,0,4,1,67,18,2,2000,-1:-1,hex,show,placebo,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"