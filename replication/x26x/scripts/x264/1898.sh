#!/bin/sh

numb='1899'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-weightb --aq-strength 2.0 --ipratio 1.3 --pbratio 1.0 --psy-rd 4.6 --qblur 0.2 --qcomp 0.7 --vbv-init 0.4 --aq-mode 3 --b-adapt 2 --bframes 2 --crf 0 --keyint 250 --lookahead-threads 1 --min-keyint 25 --qp 40 --qpstep 3 --qpmin 4 --qpmax 68 --rc-lookahead 28 --ref 5 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset placebo --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,2.0,1.3,1.0,4.6,0.2,0.7,0.4,3,2,2,0,250,1,25,40,3,4,68,28,5,2000,1:1,dia,show,placebo,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"