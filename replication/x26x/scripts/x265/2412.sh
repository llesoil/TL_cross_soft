#!/bin/sh

numb='2413'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --weightb --aq-strength 2.5 --ipratio 1.5 --pbratio 1.4 --psy-rd 0.6 --qblur 0.2 --qcomp 0.6 --vbv-init 0.1 --aq-mode 3 --b-adapt 1 --bframes 16 --crf 40 --keyint 290 --lookahead-threads 4 --min-keyint 20 --qp 10 --qpstep 5 --qpmin 3 --qpmax 68 --rc-lookahead 48 --ref 1 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset superfast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,2.5,1.5,1.4,0.6,0.2,0.6,0.1,3,1,16,40,290,4,20,10,5,3,68,48,1,2000,1:1,dia,show,superfast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"