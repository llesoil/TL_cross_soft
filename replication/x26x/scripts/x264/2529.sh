#!/bin/sh

numb='2530'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-weightb --aq-strength 0.0 --ipratio 1.6 --pbratio 1.1 --psy-rd 4.8 --qblur 0.5 --qcomp 0.8 --vbv-init 0.7 --aq-mode 0 --b-adapt 0 --bframes 2 --crf 10 --keyint 230 --lookahead-threads 0 --min-keyint 27 --qp 10 --qpstep 4 --qpmin 3 --qpmax 60 --rc-lookahead 18 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset placebo --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,0.0,1.6,1.1,4.8,0.5,0.8,0.7,0,0,2,10,230,0,27,10,4,3,60,18,1,1000,1:1,umh,crop,placebo,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"