#!/bin/sh

numb='2909'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --weightb --aq-strength 3.0 --ipratio 1.4 --pbratio 1.1 --psy-rd 4.0 --qblur 0.2 --qcomp 0.6 --vbv-init 0.6 --aq-mode 2 --b-adapt 2 --bframes 4 --crf 25 --keyint 210 --lookahead-threads 1 --min-keyint 28 --qp 10 --qpstep 4 --qpmin 4 --qpmax 68 --rc-lookahead 28 --ref 5 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset superfast --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,3.0,1.4,1.1,4.0,0.2,0.6,0.6,2,2,4,25,210,1,28,10,4,4,68,28,5,2000,-1:-1,hex,show,superfast,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"