#!/bin/sh

numb='2199'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.5 --pbratio 1.2 --psy-rd 2.4 --qblur 0.6 --qcomp 0.6 --vbv-init 0.1 --aq-mode 1 --b-adapt 2 --bframes 14 --crf 25 --keyint 260 --lookahead-threads 0 --min-keyint 24 --qp 20 --qpstep 5 --qpmin 0 --qpmax 65 --rc-lookahead 18 --ref 4 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan crop --preset slower --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,0.0,1.5,1.2,2.4,0.6,0.6,0.1,1,2,14,25,260,0,24,20,5,0,65,18,4,2000,-1:-1,umh,crop,slower,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"