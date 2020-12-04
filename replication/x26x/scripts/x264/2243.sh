#!/bin/sh

numb='2244'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-weightb --aq-strength 0.5 --ipratio 1.2 --pbratio 1.4 --psy-rd 1.0 --qblur 0.3 --qcomp 0.8 --vbv-init 0.2 --aq-mode 3 --b-adapt 0 --bframes 12 --crf 30 --keyint 280 --lookahead-threads 4 --min-keyint 30 --qp 10 --qpstep 3 --qpmin 0 --qpmax 65 --rc-lookahead 48 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset placebo --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,0.5,1.2,1.4,1.0,0.3,0.8,0.2,3,0,12,30,280,4,30,10,3,0,65,48,2,2000,-2:-2,umh,show,placebo,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"