#!/bin/sh

numb='1781'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-weightb --aq-strength 1.0 --ipratio 1.1 --pbratio 1.4 --psy-rd 2.8 --qblur 0.5 --qcomp 0.6 --vbv-init 0.5 --aq-mode 3 --b-adapt 1 --bframes 4 --crf 50 --keyint 260 --lookahead-threads 3 --min-keyint 29 --qp 20 --qpstep 3 --qpmin 4 --qpmax 69 --rc-lookahead 28 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset superfast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,1.0,1.1,1.4,2.8,0.5,0.6,0.5,3,1,4,50,260,3,29,20,3,4,69,28,1,1000,-1:-1,dia,crop,superfast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"