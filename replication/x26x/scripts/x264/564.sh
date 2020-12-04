#!/bin/sh

numb='565'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-weightb --aq-strength 2.0 --ipratio 1.5 --pbratio 1.1 --psy-rd 3.0 --qblur 0.6 --qcomp 0.6 --vbv-init 0.8 --aq-mode 0 --b-adapt 2 --bframes 10 --crf 5 --keyint 200 --lookahead-threads 2 --min-keyint 26 --qp 10 --qpstep 4 --qpmin 3 --qpmax 69 --rc-lookahead 48 --ref 1 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset medium --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,2.0,1.5,1.1,3.0,0.6,0.6,0.8,0,2,10,5,200,2,26,10,4,3,69,48,1,2000,1:1,umh,show,medium,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"