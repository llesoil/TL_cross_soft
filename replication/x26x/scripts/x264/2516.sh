#!/bin/sh

numb='2517'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --weightb --aq-strength 0.0 --ipratio 1.6 --pbratio 1.3 --psy-rd 1.2 --qblur 0.3 --qcomp 0.9 --vbv-init 0.9 --aq-mode 3 --b-adapt 0 --bframes 6 --crf 0 --keyint 290 --lookahead-threads 2 --min-keyint 23 --qp 20 --qpstep 4 --qpmin 1 --qpmax 61 --rc-lookahead 18 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset veryfast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,0.0,1.6,1.3,1.2,0.3,0.9,0.9,3,0,6,0,290,2,23,20,4,1,61,18,3,2000,1:1,dia,show,veryfast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"