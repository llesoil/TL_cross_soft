#!/bin/sh

numb='1622'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-weightb --aq-strength 0.0 --ipratio 1.6 --pbratio 1.0 --psy-rd 2.4 --qblur 0.3 --qcomp 0.7 --vbv-init 0.3 --aq-mode 0 --b-adapt 2 --bframes 4 --crf 5 --keyint 270 --lookahead-threads 2 --min-keyint 24 --qp 10 --qpstep 3 --qpmin 0 --qpmax 61 --rc-lookahead 28 --ref 5 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan crop --preset placebo --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,0.0,1.6,1.0,2.4,0.3,0.7,0.3,0,2,4,5,270,2,24,10,3,0,61,28,5,1000,1:1,hex,crop,placebo,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"