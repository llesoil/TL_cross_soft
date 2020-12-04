#!/bin/sh

numb='41'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --weightb --aq-strength 3.0 --ipratio 1.5 --pbratio 1.1 --psy-rd 2.8 --qblur 0.2 --qcomp 0.9 --vbv-init 0.2 --aq-mode 2 --b-adapt 2 --bframes 6 --crf 0 --keyint 230 --lookahead-threads 4 --min-keyint 28 --qp 40 --qpstep 4 --qpmin 1 --qpmax 65 --rc-lookahead 18 --ref 3 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset veryfast --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,3.0,1.5,1.1,2.8,0.2,0.9,0.2,2,2,6,0,230,4,28,40,4,1,65,18,3,2000,-2:-2,dia,show,veryfast,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"