#!/bin/sh

numb='2377'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --weightb --aq-strength 1.5 --ipratio 1.0 --pbratio 1.1 --psy-rd 3.0 --qblur 0.2 --qcomp 0.8 --vbv-init 0.3 --aq-mode 3 --b-adapt 2 --bframes 0 --crf 20 --keyint 260 --lookahead-threads 2 --min-keyint 20 --qp 10 --qpstep 3 --qpmin 1 --qpmax 61 --rc-lookahead 38 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset veryslow --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,1.5,1.0,1.1,3.0,0.2,0.8,0.3,3,2,0,20,260,2,20,10,3,1,61,38,2,2000,-1:-1,dia,show,veryslow,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"