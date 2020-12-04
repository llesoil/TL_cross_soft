#!/bin/sh

numb='445'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.6 --pbratio 1.2 --psy-rd 2.8 --qblur 0.2 --qcomp 0.9 --vbv-init 0.0 --aq-mode 1 --b-adapt 2 --bframes 0 --crf 45 --keyint 290 --lookahead-threads 1 --min-keyint 28 --qp 0 --qpstep 5 --qpmin 0 --qpmax 64 --rc-lookahead 38 --ref 6 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset veryfast --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,3.0,1.6,1.2,2.8,0.2,0.9,0.0,1,2,0,45,290,1,28,0,5,0,64,38,6,2000,-2:-2,umh,show,veryfast,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"