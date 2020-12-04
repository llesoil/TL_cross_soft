#!/bin/sh

numb='3118'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.5 --pbratio 1.4 --psy-rd 3.0 --qblur 0.5 --qcomp 0.8 --vbv-init 0.3 --aq-mode 3 --b-adapt 1 --bframes 2 --crf 15 --keyint 210 --lookahead-threads 4 --min-keyint 22 --qp 50 --qpstep 5 --qpmin 3 --qpmax 65 --rc-lookahead 28 --ref 4 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset placebo --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,0.0,1.5,1.4,3.0,0.5,0.8,0.3,3,1,2,15,210,4,22,50,5,3,65,28,4,2000,-1:-1,umh,show,placebo,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"