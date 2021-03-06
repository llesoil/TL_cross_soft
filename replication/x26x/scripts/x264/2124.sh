#!/bin/sh

numb='2125'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-weightb --aq-strength 3.0 --ipratio 1.5 --pbratio 1.0 --psy-rd 3.4 --qblur 0.3 --qcomp 0.9 --vbv-init 0.9 --aq-mode 2 --b-adapt 0 --bframes 16 --crf 40 --keyint 290 --lookahead-threads 1 --min-keyint 26 --qp 50 --qpstep 4 --qpmin 3 --qpmax 68 --rc-lookahead 28 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan crop --preset placebo --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,3.0,1.5,1.0,3.4,0.3,0.9,0.9,2,0,16,40,290,1,26,50,4,3,68,28,2,1000,-1:-1,hex,crop,placebo,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"