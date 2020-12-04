#!/bin/sh

numb='2862'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --weightb --aq-strength 0.5 --ipratio 1.1 --pbratio 1.2 --psy-rd 0.4 --qblur 0.4 --qcomp 0.8 --vbv-init 0.8 --aq-mode 1 --b-adapt 0 --bframes 14 --crf 0 --keyint 300 --lookahead-threads 2 --min-keyint 28 --qp 50 --qpstep 4 --qpmin 3 --qpmax 67 --rc-lookahead 48 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset veryfast --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,0.5,1.1,1.2,0.4,0.4,0.8,0.8,1,0,14,0,300,2,28,50,4,3,67,48,1,1000,-2:-2,umh,show,veryfast,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"