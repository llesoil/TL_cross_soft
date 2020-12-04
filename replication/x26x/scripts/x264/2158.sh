#!/bin/sh

numb='2159'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --weightb --aq-strength 2.0 --ipratio 1.3 --pbratio 1.1 --psy-rd 2.6 --qblur 0.3 --qcomp 0.9 --vbv-init 0.9 --aq-mode 0 --b-adapt 0 --bframes 16 --crf 5 --keyint 220 --lookahead-threads 2 --min-keyint 25 --qp 50 --qpstep 5 --qpmin 4 --qpmax 63 --rc-lookahead 48 --ref 5 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset veryfast --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,2.0,1.3,1.1,2.6,0.3,0.9,0.9,0,0,16,5,220,2,25,50,5,4,63,48,5,2000,-1:-1,umh,show,veryfast,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"