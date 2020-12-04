#!/bin/sh

numb='2267'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-weightb --aq-strength 1.0 --ipratio 1.5 --pbratio 1.3 --psy-rd 4.0 --qblur 0.2 --qcomp 0.7 --vbv-init 0.2 --aq-mode 0 --b-adapt 1 --bframes 8 --crf 10 --keyint 300 --lookahead-threads 1 --min-keyint 29 --qp 30 --qpstep 5 --qpmin 4 --qpmax 67 --rc-lookahead 28 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset superfast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,1.0,1.5,1.3,4.0,0.2,0.7,0.2,0,1,8,10,300,1,29,30,5,4,67,28,1,2000,-1:-1,dia,crop,superfast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"