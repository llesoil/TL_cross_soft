#!/bin/sh

numb='2405'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --weightb --aq-strength 3.0 --ipratio 1.0 --pbratio 1.4 --psy-rd 2.8 --qblur 0.5 --qcomp 0.7 --vbv-init 0.5 --aq-mode 0 --b-adapt 1 --bframes 14 --crf 45 --keyint 230 --lookahead-threads 4 --min-keyint 21 --qp 40 --qpstep 5 --qpmin 3 --qpmax 69 --rc-lookahead 28 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan crop --preset veryfast --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,3.0,1.0,1.4,2.8,0.5,0.7,0.5,0,1,14,45,230,4,21,40,5,3,69,28,6,2000,-1:-1,umh,crop,veryfast,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"