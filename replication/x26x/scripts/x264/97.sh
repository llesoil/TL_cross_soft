#!/bin/sh

numb='98'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-weightb --aq-strength 3.0 --ipratio 1.6 --pbratio 1.3 --psy-rd 3.0 --qblur 0.6 --qcomp 0.6 --vbv-init 0.1 --aq-mode 2 --b-adapt 1 --bframes 6 --crf 30 --keyint 220 --lookahead-threads 0 --min-keyint 22 --qp 30 --qpstep 4 --qpmin 0 --qpmax 68 --rc-lookahead 28 --ref 3 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset medium --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,3.0,1.6,1.3,3.0,0.6,0.6,0.1,2,1,6,30,220,0,22,30,4,0,68,28,3,1000,-2:-2,umh,show,medium,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"