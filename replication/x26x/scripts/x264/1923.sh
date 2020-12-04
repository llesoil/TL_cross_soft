#!/bin/sh

numb='1924'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.1 --pbratio 1.2 --psy-rd 3.2 --qblur 0.2 --qcomp 0.9 --vbv-init 0.0 --aq-mode 1 --b-adapt 0 --bframes 10 --crf 45 --keyint 240 --lookahead-threads 3 --min-keyint 26 --qp 20 --qpstep 3 --qpmin 0 --qpmax 69 --rc-lookahead 48 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset superfast --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,2.5,1.1,1.2,3.2,0.2,0.9,0.0,1,0,10,45,240,3,26,20,3,0,69,48,6,1000,-2:-2,umh,crop,superfast,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"